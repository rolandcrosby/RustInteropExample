#include <stdint.h>

void rs_register_callback(
    const void* context,
    void (*callback)(
        const void* cb_context,
        const char* proto_data,
        size_t proto_length)
);

void rs_run_command(
    const char* proto_data,
    size_t proto_length
);