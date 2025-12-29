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

    // In terminals, add ghost text on the same line after a space delimiter
    // For example: "fix bug" -> "fix bug    [ghost->] by adding error handling"
    eprintln!("Rust: Entry point reached");

    // FORCE BYPASS for debugging:
    // if keyboard::simulate::is_terminal() {
    //    if !keyboard::simulate::type_delimiter() { return false; }
    //    thread::sleep(Duration::from_millis(10));
    // } else {
        eprintln!("Rust: Simulating Shift+Enter...");
        // In regular apps, keep the two-line-down behavior
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
    // }
    
    // Shared by both modes: Actually paste the text
    // MOVED TO SWIFT: Rust now only handles layout (Shift+Enter / Tab)
    // if let Err(e) = keyboard::paste::insert_via_clipboard(text) {
    //     eprintln!("Paste failed: {}", e);
    //     return false;
    // }
    
    true
}
