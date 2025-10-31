#include "flow_runtime.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

// Configuration from environment
static int g_initialized = 0;
static int g_verbose = 0;
static FILE *g_log_file = NULL;

// TODO: Add shared memory or IPC communication here
// For now, we log to stderr or a file

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
}

void flow_init(void) { init_from_env(); }

void flow_shutdown(void) {
  if (!g_initialized)
    return;

  if (g_verbose) {
    fprintf(g_log_file, "[flow_runtime] Shutting down\n");
  }

  if (g_log_file && g_log_file != stderr) {
    fclose(g_log_file);
    g_log_file = NULL;
  }

  g_initialized = 0;
}

void flow_report_source(void *data, size_t size, int src_id) {
  init_from_env();

  // Log the source event
  fprintf(g_log_file, "[flow_runtime] SOURCE: SRC_ID=%d, ptr=%p, size=%zu\n",
          src_id, data, size);

  // If verbose, dump the data in hex
  if (g_verbose && data && size > 0) {
    fprintf(g_log_file, "[flow_runtime]   Data (hex): ");
    unsigned char *bytes = (unsigned char *)data;
    size_t dump_size = size > 64 ? 64 : size; // Limit to 64 bytes
    for (size_t i = 0; i < dump_size; i++) {
      fprintf(g_log_file, "%02x ", bytes[i]);
    }
    if (size > 64) {
      fprintf(g_log_file, "... (%zu more bytes)", size - 64);
    }
    fprintf(g_log_file, "\n");
  }

  fflush(g_log_file);

  // TODO: Send to monitoring service via shared memory or IPC
  // Example:
  //   shm_write_source_event(src_id, data, size);
  //   or
  //   send_to_monitor(MSG_SOURCE, src_id, data, size);
}

void flow_report_sink(void *data, size_t size, int sink_id) {
  init_from_env();

  // Log the sink event
  fprintf(g_log_file, "[flow_runtime] SINK: SINK_ID=%d, ptr=%p, size=%zu\n",
          sink_id, data, size);

  // If verbose, dump the data in hex
  if (g_verbose && data && size > 0) {
    fprintf(g_log_file, "[flow_runtime]   Data (hex): ");
    unsigned char *bytes = (unsigned char *)data;
    size_t dump_size = size > 64 ? 64 : size; // Limit to 64 bytes
    for (size_t i = 0; i < dump_size; i++) {
      fprintf(g_log_file, "%02x ", bytes[i]);
    }
    if (size > 64) {
      fprintf(g_log_file, "... (%zu more bytes)", size - 64);
    }
    fprintf(g_log_file, "\n");
  }

  fflush(g_log_file);

  // TODO: Send to monitoring service via shared memory or IPC
  // Example:
  //   shm_write_sink_event(sink_id, data, size);
  //   or
  //   send_to_monitor(MSG_SINK, sink_id, data, size);
}

// Compatibility wrappers for LLVM pass (maintains existing function names)
void sample_report_source(void *data, int size, int src_id) {
  flow_report_source(data, (size_t)size, src_id);
}

void sample_report_sink(void *data, int size, int sink_id) {
  flow_report_sink(data, (size_t)size, sink_id);
}
