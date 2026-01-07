pub mod keyboard {
    pub mod simulate;
    pub mod paste;
    pub mod text_reader;
}

use std::ffi::{CStr, c_char};
use std::sync::Mutex;

// Global state to track ghost text and old clipboard
static OLD_CLIPBOARD: Mutex<Option<String>> = Mutex::new(None);
static GHOST_TEXT_LENGTH: Mutex<usize> = Mutex::new(0);

/// FFI: Insert ghost text (Shift+Enter x2 + paste)
/// Saves old clipboard for later restore
#[no_mangle]
pub extern "C" fn superspeed_insert_ghost_text_v2(text_ptr: *const c_char) -> bool {
    let text = unsafe {
        if text_ptr.is_null() {
            eprintln!("Null text pointer");
            return false;
        }
        CStr::from_ptr(text_ptr).to_string_lossy().into_owned()
    };

    eprintln!("Rust: Insert ghost text: '{}'", text);

    if text.is_empty() {
        return true;
    }

    // Step 1: Shift+Enter x2 for layout
    eprintln!("Rust: Creating layout (Shift+Enter x2)");
    if !keyboard::simulate::shift_enter() {
        eprintln!("Rust: Shift+Enter 1 failed");
        return false;
    }
    if !keyboard::simulate::shift_enter() {
        eprintln!("Rust: Shift+Enter 2 failed");
        return false;
    }

    // Wait for Shift+Enter to complete before pasting
    eprintln!("⏳ Waiting for layout to complete...");
    std::thread::sleep(std::time::Duration::from_millis(100));

    // Step 2: Save text length for later deletion
    *GHOST_TEXT_LENGTH.lock().unwrap() = text.len();

    // Step 3: Paste ghost text (saves old clipboard internally)
    eprintln!("Rust: Pasting ghost text");
    match keyboard::paste::insert_via_clipboard_and_save(&text) {
        Ok(old_clipboard) => {
            // Save old clipboard to global for Tab/Esc handling
            *OLD_CLIPBOARD.lock().unwrap() = old_clipboard;
            eprintln!("Rust: ✅ Ghost text inserted");
            true
        }
        Err(e) => {
            eprintln!("Rust: Paste failed: {}", e);
            false
        }
    }
}

/// FFI: Accept ghost text (Tab key)
/// Restores old clipboard, keeps ghost text
#[no_mangle]
pub extern "C" fn superspeed_accept_ghost_text() -> bool {
    eprintln!("Rust: Accept ghost text (Tab)");

    // Just restore old clipboard
    if let Err(e) = restore_old_clipboard() {
        eprintln!("Rust: Failed to restore clipboard: {}", e);
        return false;
    }

    eprintln!("Rust: ✅ Ghost text accepted, clipboard restored");
    true
}

/// FFI: Reject ghost text (Esc key)
/// Deletes ghost text and restores old clipboard
#[no_mangle]
pub extern "C" fn superspeed_reject_ghost_text() -> bool {
    eprintln!("Rust: Reject ghost text (Esc)");

    // Step 1: Delete ghost text (backspace N times)
    let delete_count = {
        let length = *GHOST_TEXT_LENGTH.lock().unwrap();
        length + 2  // Ghost text + 2 newlines from Shift+Enter
    };

    eprintln!("Rust: Deleting {} characters", delete_count);
    for i in 0..delete_count {
        if !keyboard::simulate::backspace() {
            eprintln!("Rust: Backspace {} failed", i);
            return false;
        }
    }

    // Step 2: Restore old clipboard
    if let Err(e) = restore_old_clipboard() {
        eprintln!("Rust: Failed to restore clipboard: {}", e);
        return false;
    }

    eprintln!("Rust: ✅ Ghost text rejected, clipboard restored");
    true
}

/// Helper: Restore old clipboard from global state
fn restore_old_clipboard() -> Result<(), String> {
    let old_clipboard = OLD_CLIPBOARD.lock().unwrap().take();

    if let Some(old_text) = old_clipboard {
        keyboard::paste::restore_clipboard(&old_text)
    } else {
        eprintln!("Rust: No old clipboard to restore");
        Ok(())
    }
}

/// FFI: Read cursor context (text before cursor)
/// Returns null-terminated C string, or null pointer on error
/// Caller must free the returned string with superspeed_free_string()
#[no_mangle]
pub extern "C" fn superspeed_read_cursor_context(char_count: usize) -> *mut c_char {
    eprintln!("Rust: Reading {} characters before cursor", char_count);

    match keyboard::text_reader::read_cursor_context(char_count) {
        Ok(text) => {
            eprintln!("Rust: ✅ Read cursor context: '{}'", text);
            // Convert Rust String to C string
            match std::ffi::CString::new(text) {
                Ok(c_string) => c_string.into_raw(),
                Err(e) => {
                    eprintln!("Rust: Failed to convert to C string: {}", e);
                    std::ptr::null_mut()
                }
            }
        }
        Err(e) => {
            eprintln!("Rust: ❌ Failed to read cursor context: {}", e);
            std::ptr::null_mut()
        }
    }
}

/// FFI: Free string allocated by Rust
#[no_mangle]
pub extern "C" fn superspeed_free_string(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe {
            let _ = std::ffi::CString::from_raw(ptr);
        }
    }
}
