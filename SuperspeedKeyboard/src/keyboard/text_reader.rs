// Read text from cursor using clipboard trick (like ito)
use cocoa::appkit::{NSPasteboard, NSPasteboardTypeString};
use cocoa::base::nil;
use cocoa::foundation::{NSAutoreleasePool, NSString};
use core_graphics::event::{CGEvent, CGEventFlags, CGEventTapLocation, CGKeyCode};
use core_graphics::event_source::{CGEventSource, CGEventSourceStateID};
use std::ffi::CStr;
use std::thread;
use std::time::Duration;

// macOS key codes
const KVK_LEFT_ARROW: u16 = 123;
const KVK_RIGHT_ARROW: u16 = 124;
const KVK_C: u16 = 8;

/// Read N characters before cursor using clipboard trick
/// Returns the text before cursor (or error)
pub fn read_cursor_context(char_count: usize) -> Result<String, String> {
    unsafe {
        let _pool = NSAutoreleasePool::new(nil);
        let pasteboard = NSPasteboard::generalPasteboard(nil);

        // Save original clipboard
        let old_contents = pasteboard.stringForType(NSPasteboardTypeString);
        let original_clipboard = if old_contents != nil {
            let c_str = NSString::UTF8String(old_contents);
            CStr::from_ptr(c_str).to_string_lossy().into_owned()
        } else {
            String::new()
        };

        // Clear clipboard
        pasteboard.clearContents();

        // Select previous N characters with Shift+Left Arrow
        select_previous_chars(char_count)?;

        // Copy selection with Cmd+C
        simulate_cmd_c()?;

        // Wait for clipboard to update
        thread::sleep(Duration::from_millis(50));

        // Read the selected text from clipboard
        let current_contents = pasteboard.stringForType(NSPasteboardTypeString);
        let context_text = if current_contents != nil {
            let c_str = NSString::UTF8String(current_contents);
            CStr::from_ptr(c_str).to_string_lossy().into_owned()
        } else {
            String::new()
        };

        // Restore cursor position (move right to deselect)
        restore_cursor_position(char_count)?;

        // Restore original clipboard
        pasteboard.clearContents();
        if !original_clipboard.is_empty() {
            let ns_string = NSString::alloc(nil).init_str(&original_clipboard);
            pasteboard.setString_forType(ns_string, NSPasteboardTypeString);
        }

        Ok(context_text)
    }
}

/// Select N characters before cursor using Shift+Left Arrow
fn select_previous_chars(char_count: usize) -> Result<(), String> {
    let source = CGEventSource::new(CGEventSourceStateID::CombinedSessionState)
        .map_err(|_| "Failed to create event source")?;

    for _ in 0..char_count {
        // Press Shift+Left Arrow (selects one char to the left)
        let left_down = CGEvent::new_keyboard_event(source.clone(), KVK_LEFT_ARROW as CGKeyCode, true)
            .map_err(|_| "Failed to create left arrow down event")?;
        let left_up = CGEvent::new_keyboard_event(source.clone(), KVK_LEFT_ARROW as CGKeyCode, false)
            .map_err(|_| "Failed to create left arrow up event")?;

        // Set Shift flag for selection
        left_down.set_flags(CGEventFlags::CGEventFlagShift);
        left_up.set_flags(CGEventFlags::CGEventFlagShift);

        // Post events
        left_down.post(CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(2));
        left_up.post(CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(1));
    }

    // Allow selection to complete
    thread::sleep(Duration::from_millis(10));

    Ok(())
}

/// Simulate Cmd+C to copy selection
fn simulate_cmd_c() -> Result<(), String> {
    let source = CGEventSource::new(CGEventSourceStateID::CombinedSessionState)
        .map_err(|_| "Failed to create event source")?;

    let c_down = CGEvent::new_keyboard_event(source.clone(), KVK_C as CGKeyCode, true)
        .map_err(|_| "Failed to create C down event")?;
    let c_up = CGEvent::new_keyboard_event(source.clone(), KVK_C as CGKeyCode, false)
        .map_err(|_| "Failed to create C up event")?;

    // Set Command flag
    c_down.set_flags(CGEventFlags::CGEventFlagCommand);
    c_up.set_flags(CGEventFlags::CGEventFlagCommand);

    // Post events
    c_down.post(CGEventTapLocation::HID);
    thread::sleep(Duration::from_millis(10));
    c_up.post(CGEventTapLocation::HID);

    Ok(())
}

/// Restore cursor position by moving right (deselects)
fn restore_cursor_position(char_count: usize) -> Result<(), String> {
    let source = CGEventSource::new(CGEventSourceStateID::CombinedSessionState)
        .map_err(|_| "Failed to create event source")?;

    for _ in 0..char_count {
        let right_down = CGEvent::new_keyboard_event(source.clone(), KVK_RIGHT_ARROW as CGKeyCode, true)
            .map_err(|_| "Failed to create right arrow down event")?;
        let right_up = CGEvent::new_keyboard_event(source.clone(), KVK_RIGHT_ARROW as CGKeyCode, false)
            .map_err(|_| "Failed to create right arrow up event")?;

        // Post events (no Shift flag = deselects while moving)
        right_down.post(CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(2));
        right_up.post(CGEventTapLocation::HID);

        if char_count > 1 {
            thread::sleep(Duration::from_millis(1));
        }
    }

    Ok(())
}
