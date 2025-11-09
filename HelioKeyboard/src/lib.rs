// Helio Keyboard - Rust Library for Low-Level Keyboard Simulation
//
// This library provides ONLY low-level system operations:
// - Keyboard event simulation (Shift+Enter, Cmd+V)
// - Clipboard manipulation (save/restore)
//
// Business logic (AI agents, mode detection) is in Swift/Python, NOT here.

mod keyboard;

use std::ffi::{CStr, c_char};
use std::thread;
use std::time::Duration;

/// Main FFI entry point - Insert ghost text 2 lines below
///
/// Called from Swift with a C string containing the ghost text to insert.
///
/// Process:
/// 1. Shift+Enter twice (creates blank line separator)
/// 2. Insert text via clipboard paste
///
/// Returns true on success, false on failure.
#[no_mangle]
pub extern "C" fn helio_insert_ghost_text(text_ptr: *const c_char) -> bool {
    // Convert C string to Rust string
    let text = unsafe {
        if text_ptr.is_null() {
            eprintln!("❌ Null pointer received from Swift");
            return false;
        }
        match CStr::from_ptr(text_ptr).to_str() {
            Ok(s) => s,
            Err(e) => {
                eprintln!("❌ Failed to convert C string to UTF-8: {}", e);
                return false;
            }
        }
    };

    println!("🦀 Rust received text from Swift: \"{}\"", text);

    // Step 1: Create blank line separator (Shift+Enter twice)
    println!("⌨️  Simulating Shift+Enter #1...");
    if !keyboard::simulate::shift_enter() {
        eprintln!("❌ Failed to simulate first Shift+Enter");
        return false;
    }
    thread::sleep(Duration::from_millis(10));

    println!("⌨️  Simulating Shift+Enter #2...");
    if !keyboard::simulate::shift_enter() {
        eprintln!("❌ Failed to simulate second Shift+Enter");
        return false;
    }
    thread::sleep(Duration::from_millis(10));

    // Step 2: Insert text via clipboard
    println!("📋 Inserting text via clipboard...");
    match keyboard::paste::insert_via_clipboard(text) {
        Ok(_) => {
            println!("✅ Ghost text inserted successfully");
            true
        }
        Err(e) => {
            eprintln!("❌ Failed to insert text: {}", e);
            false
        }
    }
}
