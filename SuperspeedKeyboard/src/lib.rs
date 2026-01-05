pub mod keyboard {
    pub mod simulate;
    pub mod paste;
}

use std::ffi::{CStr, c_char};
use std::thread;
use std::time::Duration;

/// FFI entry: insert ghost text in an app-aware manner
#[no_mangle]
pub extern "C" fn superspeed_insert_ghost_text_v2(text_ptr: *const c_char) -> bool {
    let text = unsafe {
        if text_ptr.is_null() {
            eprintln!("Null text pointer");
            return false;
        }
        CStr::from_ptr(text_ptr).to_string_lossy().into_owned()
    };

    eprintln!("Rust: Entry point reached with text: '{}'", text);

    // Only do layout if text is not empty (empty string = testing layout only)
    if !text.is_empty() {
        // Step 1: Create layout (Shift+Enter x2)
        eprintln!("Rust: Creating layout (Shift+Enter x2)");
        if !keyboard::simulate::shift_enter() {
            eprintln!("Rust: Shift+Enter 1 failed");
            return false;
        }
        thread::sleep(Duration::from_millis(10));

        if !keyboard::simulate::shift_enter() {
            eprintln!("Rust: Shift+Enter 2 failed");
            return false;
        }
        thread::sleep(Duration::from_millis(10));

        // Step 2: Paste the actual text via clipboard (like ito does)
        eprintln!("Rust: Pasting text via clipboard");
        if let Err(e) = keyboard::paste::insert_via_clipboard(&text) {
            eprintln!("Rust: Paste failed: {}", e);
            return false;
        }
        eprintln!("Rust: ✅ Layout + paste completed");
    } else {
        eprintln!("Rust: Empty text, only doing layout");
        if !keyboard::simulate::shift_enter() {
            eprintln!("Rust: Shift+Enter 1 failed");
            return false;
        }
        thread::sleep(Duration::from_millis(10));

        if !keyboard::simulate::shift_enter() {
            eprintln!("Rust: Shift+Enter 2 failed");
            return false;
        }
    }

    true
}
