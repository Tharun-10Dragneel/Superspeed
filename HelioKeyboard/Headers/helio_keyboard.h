// helio_keyboard.h
// Public C API exported by the Rust cdylib/staticlib.

#ifndef HELIO_KEYBOARD_H
#define HELIO_KEYBOARD_H

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// Insert ghost text two lines below using synthetic keystrokes + clipboard.
// Returns true on success, false on failure.
// IMPORTANT: Call from the main thread (NSPasteboard is not thread-safe).
// V2: Renamed to break stale linkage
bool helio_insert_ghost_text_v2(const char *text);

#ifdef __cplusplus
}
#endif

#endif // HELIO_KEYBOARD_H
