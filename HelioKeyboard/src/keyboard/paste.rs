// Clipboard operations
// Handles saving, setting, and restoring clipboard contents

use cocoa::appkit::{NSPasteboard, NSPasteboardTypeString};
use cocoa::base::nil;
use cocoa::foundation::{NSAutoreleasePool, NSString};
use std::ffi::CStr;
use std::thread;
use std::time::Duration;

use super::simulate;

/// Insert text using clipboard paste method (ITO's proven approach)
///
/// Steps:
/// 1. Save current clipboard
/// 2. Put text in clipboard
/// 3. Verify clipboard was set (retry up to 50 times)
/// 4. Simulate Cmd+V to paste
/// 5. Restore original clipboard after 1 second
pub fn insert_via_clipboard(text: &str) -> Result<(), String> {
    unsafe {
        let _pool = NSAutoreleasePool::new(nil);
        let pasteboard = NSPasteboard::generalPasteboard(nil);

        // Step 1: Save old clipboard contents
        let old_contents = pasteboard.stringForType(NSPasteboardTypeString);
        println!("💾 Saved original clipboard");

        // Step 2: Clear clipboard and set new text
        pasteboard.clearContents();
        let ns_string = NSString::alloc(nil).init_str(text);
        pasteboard.setString_forType(ns_string, NSPasteboardTypeString);

        // Step 3: Verify clipboard was set (retry up to 50 times like ITO)
        let mut attempts = 0;
        loop {
            let current = pasteboard.stringForType(NSPasteboardTypeString);
            if current != nil {
                let current_str = cocoa::foundation::NSString::UTF8String(current);
                let rust_str = CStr::from_ptr(current_str).to_string_lossy();
                if rust_str == text {
                    break; // Success!
                }
            }
            attempts += 1;
            if attempts > 50 {
                return Err("Failed to verify clipboard was set after 50 attempts".into());
            }
            thread::sleep(Duration::from_millis(2));
        }

        println!("✅ Clipboard verified after {} attempts", attempts);

        // Step 4: Simulate Cmd+V (paste)
        if !simulate::cmd_v() {
            return Err("Failed to simulate Cmd+V".into());
        }
        println!("✅ Cmd+V simulated");

        // Step 5: Restore original clipboard after 1 second
        thread::sleep(Duration::from_secs(1));
        if old_contents != nil {
            let old_str = {
                let c_str = cocoa::foundation::NSString::UTF8String(old_contents);
                CStr::from_ptr(c_str).to_string_lossy().into_owned()
            };

            let pasteboard = NSPasteboard::generalPasteboard(nil);
            pasteboard.clearContents();
            let ns_string = NSString::alloc(nil).init_str(&old_str);
            pasteboard.setString_forType(ns_string, NSPasteboardTypeString);
            println!("✅ Original clipboard restored");
        }

        Ok(())
    }
}
