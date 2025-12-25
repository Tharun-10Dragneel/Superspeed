// Modern 2025 clipboard handling using objc2 (no deprecated cocoa crate)
use std::ffi::{CStr, CString};
use std::thread;
use std::time::Duration;
use objc::{msg_send, sel, sel_impl, class};
use objc::runtime::{Object, BOOL, YES};
use crate::keyboard::simulate;

// Helper to create NSString from Rust string
fn ns_string(s: &str) -> *mut Object {
    unsafe {
        let ns_str: *mut Object = msg_send![class!(NSString), alloc];
        let c_str = CString::new(s).unwrap();
        let init_str: *mut Object = msg_send![ns_str, initWithUTF8String:c_str.as_ptr()];
        init_str
    }
}

// Helper to get Rust string from NSString
fn rust_string(ns_str: *mut Object) -> String {
    unsafe {
        let c_str: *const i8 = msg_send![ns_str, UTF8String];
        if c_str.is_null() {
            return String::new();
        }
        CStr::from_ptr(c_str).to_string_lossy().into_owned()
    }
}

/// Insert text via clipboard with smart paste and verification
pub fn insert_via_clipboard(text: &str) -> Result<(), String> {
    unsafe {
        // 1. Get General Pasteboard
        let pasteboard: *mut Object = msg_send![class!(NSPasteboard), generalPasteboard];
        if pasteboard.is_null() {
            return Err("Failed to get general pasteboard".into());
        }

        // NSPasteboardTypeString is a global constant string
        // We need to fetch it dynamically or just use the string value "public.utf8-plain-text" 
        // which works universally on modern macOS
        let type_string = ns_string("public.utf8-plain-text");

        // 2. Save current clipboard content (Optimization: only text)
        let old_contents_obj: *mut Object = msg_send![pasteboard, stringForType:type_string];
        let old_contents = if !old_contents_obj.is_null() {
            Some(rust_string(old_contents_obj))
        } else {
            None
        };

        // 3. Clear and Set new text
        let _: i32 = msg_send![pasteboard, clearContents];
        
        let new_text_obj = ns_string(text);
        let success: BOOL = msg_send![pasteboard, setString:new_text_obj forType:type_string];
        
        if success != YES {
            return Err("Failed to set string to pasteboard".into());
        }

        // 4. Verify (Optional but good safety)
        let mut verified = false;
        for _ in 0..10 {
            let current_obj: *mut Object = msg_send![pasteboard, stringForType:type_string];
            if !current_obj.is_null() && rust_string(current_obj) == text {
                verified = true;
                break;
            }
            thread::sleep(Duration::from_millis(5));
        }

        if !verified {
             return Err("Clipboard verification failed".into());
        }

        // 5. Simulate Cmd+V
        if !simulate::cmd_v() {
            return Err("Failed to simulate Cmd+V".into());
        }

        // 6. Restore original clipboard
        if let Some(old_text) = old_contents {
            // Wait for paste to consume the clipboard (1000ms safe buffer)
            thread::sleep(Duration::from_millis(1000));
            
            let _: i32 = msg_send![pasteboard, clearContents];
            let old_text_obj = ns_string(&old_text);
            let _: BOOL = msg_send![pasteboard, setString:old_text_obj forType:type_string];
        }

        Ok(())
    }
}
