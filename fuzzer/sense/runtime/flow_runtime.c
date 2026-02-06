#include "flow_runtime.h"
#include "flow_shm.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>
#include <xxhash.h>

#define MAX_CSTR (1u << 20) // 1 MiB cap for C-string lengths

// Shared memory state
static FlowEventBuffer *g_shm_buffer = NULL;
static int g_shm_fd = -1;
static size_t g_shm_size = 0;
static char g_shm_name[64] = {0};

// Configuration from environment
static int g_initialized = 0;
static int g_verbose = 0;
static FILE *g_log_file = NULL;
// Number of writers currently populating event slots (in-flight)
static uint32_t g_writers_inflight = 0;

// Get monotonic timestamp in nanoseconds
static uint64_t get_monotonic_ns(void) {
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
}

static size_t clamp_cstr_len(const char *s) {
  if (s == NULL)
    return 0;
  return strnlen(s, MAX_CSTR);
}

// Hash data using xxHash64
static uint64_t hash_data(const void *data, size_t size) {
  return XXH64(data, size, 0); // seed = 0
}

static void init_shared_memory(void) {
  // Create shared memory name based on PID
  pid_t pid = getpid();
  snprintf(g_shm_name, sizeof(g_shm_name), "/flow_events_%d", pid);

  // Calculate size
  g_shm_size = flow_event_buffer_size(FLOW_EVENT_MAX_EVENTS);

  // Create shared memory object
  g_shm_fd = shm_open(g_shm_name, O_CREAT | O_RDWR, 0600);
  if (g_shm_fd == -1) {
    fprintf(stderr,
            "[flow_runtime] ERROR: Failed to create shared memory: %s\n",
            g_shm_name);
    return;
  }

  // Set size
  if (ftruncate(g_shm_fd, g_shm_size) == -1) {
    fprintf(stderr, "[flow_runtime] ERROR: Failed to set shared memory size\n");
    close(g_shm_fd);
    shm_unlink(g_shm_name);
    g_shm_fd = -1;
    return;
  }

  // Map shared memory
  g_shm_buffer = (FlowEventBuffer *)mmap(
      NULL, g_shm_size, PROT_READ | PROT_WRITE, MAP_SHARED, g_shm_fd, 0);
  if (g_shm_buffer == MAP_FAILED) {
    fprintf(stderr, "[flow_runtime] ERROR: Failed to map shared memory\n");
    close(g_shm_fd);
    shm_unlink(g_shm_name);
    g_shm_fd = -1;
    g_shm_buffer = NULL;
    return;
  }

  // Initialize header atomically
  // Note: ftruncate() guarantees zero-initialization, so completed is already 0
  // But we explicitly initialize all fields for clarity and safety
  __atomic_store_n(&g_shm_buffer->num_events, 0, __ATOMIC_RELAXED);
  __atomic_store_n(&g_shm_buffer->max_events, FLOW_EVENT_MAX_EVENTS,
                   __ATOMIC_RELAXED);
  __atomic_store_n(&g_shm_buffer->completed, 0, __ATOMIC_RELEASE);
  g_shm_buffer->padding = 0;

  if (g_verbose) {
    fprintf(g_log_file,
            "[flow_runtime] Created shared memory: %s (%zu bytes)\n",
            g_shm_name, g_shm_size);
  }
}

static void init_from_env(void) {
  if (g_initialized)
    return;
  g_initialized = 1;

  // Check if verbose logging is enabled
  const char *verbose_str = getenv("FLOW_VERBOSE");
  if (verbose_str && *verbose_str) {
    g_verbose = atoi(verbose_str);
  }

  // Check if we should log to a file
  const char *log_path = getenv("FLOW_LOG_FILE");
  if (log_path && *log_path) {
    g_log_file = fopen(log_path, "a");
    if (!g_log_file) {
      fprintf(stderr, "[flow_runtime] WARNING: Failed to open log file: %s\n",
              log_path);
      g_log_file = stderr;
    }
  } else {
    g_log_file = stderr;
  }

  if (g_verbose) {
    fprintf(g_log_file, "[flow_runtime] Initialized (PID=%d)\n", getpid());
    fprintf(g_log_file, "[flow_runtime] FLOW_VERBOSE=%d\n", g_verbose);
    fprintf(g_log_file, "[flow_runtime] FLOW_LOG_FILE=%s\n",
            log_path ? log_path : "(stderr)");
  }

  // Initialize shared memory
  init_shared_memory();
}

void flow_init(void) { init_from_env(); }

static void cleanup_shared_memory(void) {
  if (g_shm_buffer != NULL && g_shm_buffer != MAP_FAILED) {
    munmap(g_shm_buffer, g_shm_size);
    g_shm_buffer = NULL;
  }

  if (g_shm_fd != -1) {
    close(g_shm_fd);
    g_shm_fd = -1;
  }

  // Note: We do NOT unlink the shared memory here!
  // The monitor service needs to read it after the process exits.
  // The monitor will unlink it after processing.
}

void flow_shutdown(void) {
  if (!g_initialized)
    return;

  // Wait for any in-flight writers to finish populating event slots.
  // This prevents a race where the monitor (which only reads the buffer
  // after `completed` is set) might see num_events that include slots
  // reserved but not yet written.
  while (__atomic_load_n(&g_writers_inflight, __ATOMIC_ACQUIRE) != 0) {
    if (g_verbose) {
      fprintf(g_log_file,
              "[flow_runtime] Waiting for %u in-flight writers before "
              "marking completed\n",
              g_writers_inflight);
    }
    /* short sleep to avoid busy-waiting */
    usleep(1000);
  }

  // Mark buffer as completed (atomic write so monitor can detect it)
  if (g_shm_buffer != NULL) {
    __atomic_store_n(&g_shm_buffer->completed, 1, __ATOMIC_RELEASE);
  }

  if (g_verbose) {
    fprintf(g_log_file, "[flow_runtime] Shutting down (recorded %u events)\n",
            g_shm_buffer ? g_shm_buffer->num_events : 0);
  }

  // Cleanup shared memory
  cleanup_shared_memory();

  if (g_log_file && g_log_file != stderr) {
    fclose(g_log_file);
    g_log_file = NULL;
  }

  g_initialized = 0;
}

// Destructor: automatically called at program exit
__attribute__((destructor)) static void flow_exit_handler(void) {
  flow_shutdown();
}

void flow_report_source(void *data, size_t size, int src_id) {
  init_from_env();
  // Mark writer in-flight so shutdown can wait for completion
  __atomic_fetch_add(&g_writers_inflight, 1, __ATOMIC_ACQ_REL);

  // Write to shared memory
  if (g_shm_buffer != NULL) {
    uint32_t idx =
        __atomic_fetch_add(&g_shm_buffer->num_events, 1, __ATOMIC_RELAXED);

    if (idx >= g_shm_buffer->max_events) {
      if (g_verbose) {
        fprintf(g_log_file,
                "[flow_runtime] WARNING: Event buffer full, dropping SOURCE "
                "event (src_id=%d)\n",
                src_id);
      }
      __atomic_fetch_sub(&g_writers_inflight, 1, __ATOMIC_ACQ_REL);
      return;
    }

    FlowEvent *event = &g_shm_buffer->events[idx];
    event->type = FLOW_EVENT_SOURCE;
    event->id = (uint32_t)src_id;
    event->timestamp = get_monotonic_ns();
    event->data_hash = hash_data(data, size);
    event->data_size = (uint32_t)size;
    event->padding = 0;
  }

  // Writer finished
  __atomic_fetch_sub(&g_writers_inflight, 1, __ATOMIC_ACQ_REL);

  // Also log if verbose mode enabled
  if (g_verbose) {
    fprintf(g_log_file, "[flow_runtime] SOURCE: SRC_ID=%d, ptr=%p, size=%zu\n",
            src_id, data, size);

    if (data && size > 0) {
      fprintf(g_log_file, "[flow_runtime]   Data (hex): ");
      unsigned char *bytes = (unsigned char *)data;
      size_t dump_size = size > 64 ? 64 : size;
      for (size_t i = 0; i < dump_size; i++) {
        fprintf(g_log_file, "%02x ", bytes[i]);
      }
      if (size > 64) {
        fprintf(g_log_file, "... (%zu more bytes)", size - 64);
      }
      fprintf(g_log_file, "\n");
    }

    fflush(g_log_file);
  }
}

void flow_report_sink(void *data, size_t size, int sink_id) {
  init_from_env();
  // Mark writer in-flight so shutdown can wait for completion
  __atomic_fetch_add(&g_writers_inflight, 1, __ATOMIC_ACQ_REL);

  // Write to shared memory
  if (g_shm_buffer != NULL) {
    uint32_t idx =
        __atomic_fetch_add(&g_shm_buffer->num_events, 1, __ATOMIC_RELAXED);

    if (idx >= g_shm_buffer->max_events) {
      if (g_verbose) {
        fprintf(g_log_file,
                "[flow_runtime] WARNING: Event buffer full, dropping SINK "
                "event (sink_id=%d)\n",
                sink_id);
      }
      __atomic_fetch_sub(&g_writers_inflight, 1, __ATOMIC_ACQ_REL);
      return;
    }

    FlowEvent *event = &g_shm_buffer->events[idx];
    event->type = FLOW_EVENT_SINK;
    event->id = (uint32_t)sink_id;
    event->timestamp = get_monotonic_ns();
    event->data_hash = hash_data(data, size);
    event->data_size = (uint32_t)size;
    event->padding = 0;
  }

  // Writer finished
  __atomic_fetch_sub(&g_writers_inflight, 1, __ATOMIC_ACQ_REL);

  // Also log if verbose mode enabled
  if (g_verbose) {
    fprintf(g_log_file, "[flow_runtime] SINK: SINK_ID=%d, ptr=%p, size=%zu\n",
            sink_id, data, size);

    if (data && size > 0) {
      fprintf(g_log_file, "[flow_runtime]   Data (hex): ");
      unsigned char *bytes = (unsigned char *)data;
      size_t dump_size = size > 64 ? 64 : size;
      for (size_t i = 0; i < dump_size; i++) {
        fprintf(g_log_file, "%02x ", bytes[i]);
      }
      if (size > 64) {
        fprintf(g_log_file, "... (%zu more bytes)", size - 64);
      }
      fprintf(g_log_file, "\n");
    }

    fflush(g_log_file);
  }
}

// Compatibility wrappers for LLVM pass (maintains existing function names)
void sample_report_source(void *data, int size, int src_id) {
  if (data == NULL)
    return;
  if (size == -1) {
    size = (int)clamp_cstr_len((const char *)data);
  }
  if (size <= 0)
    return;

  flow_report_source(data, (size_t)size, src_id);
}

void sample_report_sink(void *data, int size, int sink_id) {
  if (data == NULL)
    return;
  if (size == -1) {
    size = (int)clamp_cstr_len((const char *)data);
  }
  if (size <= 0)
    return;
  flow_report_sink(data, (size_t)size, sink_id);
}
