// Absolute minimal DR client for testing
#include "dr_api.h"

DR_EXPORT void dr_client_main(client_id_t id, int argc, const char *argv[]) {
  dr_fprintf(STDERR, "MINIMAL CLIENT LOADED\n");
}
