use cocoa::appkit::{NSPasteboard, NSPasteboardTypeString};
use cocoa::base::nil;
use cocoa::foundation::{NSAutoreleasePool, NSString};
use core_graphics::event::{CGEvent, CGEventFlags, CGEventTapLocation};
use core_graphics::event_source::{CGEventSource, CGEventSourceStateID};
use std::ffi::CStr;
use std::thread;
use std::time::Duration;

/// Insert text via clipboard and return old clipboard for later restore
pub fn insert_via_clipboard_and_save(text: &str) -> Result<Option<String>, String> {
    unsafe {
        // Create an autorelease pool for memory management
        let _pool = NSAutoreleasePool::new(nil);

        eprintln!("📋 Step 1: Getting pasteboard");
        let pasteboard = NSPasteboard::generalPasteboard(nil);

        // Store current clipboard contents to return for later restore
        eprintln!("📋 Step 2: Saving old clipboard");
        let old_contents = pasteboard.stringForType(NSPasteboardTypeString);
        let old_clipboard_string = if old_contents != nil {
            let c_str = cocoa::foundation::NSString::UTF8String(old_contents);
            Some(CStr::from_ptr(c_str).to_string_lossy().into_owned())
        } else {
            None
        };

        // Clear the pasteboard and set our text
        eprintln!("📋 Step 3: Clearing clipboard");
        pasteboard.clearContents();

        eprintln!("📋 Step 4: Setting new text to clipboard: '{}'", text);
        let ns_string = NSString::alloc(nil).init_str(text);
        pasteboard.setString_forType(ns_string, NSPasteboardTypeString);

        // Verify clipboard was actually set by reading it back
        eprintln!("📋 Step 5: Verifying clipboard was set");
        let mut attempts = 0;
        loop {
            let current_content = pasteboard.stringForType(NSPasteboardTypeString);
            if current_content != nil {
                let current_str = cocoa::foundation::NSString::UTF8String(current_content);
                let current_rust_str = CStr::from_ptr(current_str)
                    .to_string_lossy()
                    .into_owned();

                eprintln!("📋 Verification attempt {}: clipboard = '{}'", attempts + 1, current_rust_str);

                if current_rust_str == text {
                    eprintln!("✅ Clipboard verified!");
                    break;
                }
            }

            attempts += 1;
            if attempts > 50 {
                return Err("Failed to verify clipboard content was set".to_string());
            }
            thread::sleep(Duration::from_millis(2));
        }

        // Create event source
        eprintln!("⌨️  Step 6: Creating event source");
        let source = CGEventSource::new(CGEventSourceStateID::CombinedSessionState)
            .map_err(|_| "Failed to create event source")?;

        // Simulate Cmd+V (paste)
        eprintln!("⌨️  Step 7: Creating Cmd+V events");
        let key_v_down = CGEvent::new_keyboard_event(source.clone(), 9, true)
            .map_err(|_| "Failed to create key down event")?;
        let key_v_up = CGEvent::new_keyboard_event(source.clone(), 9, false)
            .map_err(|_| "Failed to create key up event")?;

        // Set the Command modifier flag
        key_v_down.set_flags(CGEventFlags::CGEventFlagCommand);
        key_v_up.set_flags(CGEventFlags::CGEventFlagCommand);

        // Post the events with proper delays
        eprintln!("⌨️  Step 8: Posting Cmd+V (key down)");
        key_v_down.post(CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(20));  // Delay after posting

        eprintln!("⌨️  Step 9: Posting Cmd+V (key up)");
        key_v_up.post(CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(20));  // Delay after posting

        eprintln!("✅ Cmd+V posted successfully");

        // Return old clipboard for later restore (don't restore now!)
        eprintln!("📋 Clipboard kept with AI suggestion (will restore on Tab/Esc)");

        Ok(old_clipboard_string)
    }
}

/// Restore clipboard from saved string
pub fn restore_clipboard(text: &str) -> Result<(), String> {
    unsafe {
        let _pool = NSAutoreleasePool::new(nil);
        let pasteboard = NSPasteboard::generalPasteboard(nil);

        eprintln!("📋 Restoring clipboard");
        pasteboard.clearContents();
        let ns_string = NSString::alloc(nil).init_str(text);
        pasteboard.setString_forType(ns_string, NSPasteboardTypeString);

        eprintln!("✅ Clipboard restored");
        Ok(())
    }
}
