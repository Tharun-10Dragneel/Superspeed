// superspeed_keyboard.h
// Public C API exported by the Rust cdylib/staticlib.

#ifndef SUPERSPEED_KEYBOARD_H
#define SUPERSPEED_KEYBOARD_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Insert ghost text two lines below using synthetic keystrokes + clipboard.
// Returns true on success, false on failure.
// IMPORTANT: Call from the main thread (NSPasteboard is not thread-safe).
// V2: Renamed to break stale linkage
bool superspeed_insert_ghost_text_v2(const char *text);

// Read N characters before cursor using clipboard trick (Shift+Left + Cmd+C).
// Returns a null-terminated C string, or NULL on error.
// IMPORTANT: Caller must free the returned string with superspeed_free_string().
// IMPORTANT: Call from the main thread (NSPasteboard is not thread-safe).
char *superspeed_read_cursor_context(size_t char_count);

// Free a string allocated by Rust.
// Safe to call with NULL pointer (no-op).
void superspeed_free_string(char *ptr);

#ifdef __cplusplus
}
#endif

#endif // SUPERSPEED_KEYBOARD_H
