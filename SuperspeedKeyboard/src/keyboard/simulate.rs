// Keyboard event simulation
// Creates and posts CGEvents for key presses

use core_graphics::event::{CGEvent, CGEventFlags};
use core_graphics::event_source::{CGEventSource, CGEventSourceStateID};
use std::thread;
use std::time::Duration;

/// Simulate pressing Shift+Enter (new line without sending message)
/// Used to create blank line separator before ghost text
pub fn shift_enter() -> bool {
    unsafe {
        let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
            Ok(s) => s,
            Err(_) => {
                eprintln!("❌ Failed to create event source for Shift+Enter");
                return false;
            }
        };

        // Enter key code = 36 on macOS
        let key_down = match CGEvent::new_keyboard_event(source.clone(), 36, true) {
            Ok(e) => e,
            Err(_) => {
                eprintln!("❌ Failed to create Enter key down event");
                return false;
            }
        };

        let key_up = match CGEvent::new_keyboard_event(source, 36, false) {
            Ok(e) => e,
            Err(_) => {
                eprintln!("❌ Failed to create Enter key up event");
                return false;
            }
        };

        // Add Shift modifier flag
        key_down.set_flags(CGEventFlags::CGEventFlagShift);
        key_up.set_flags(CGEventFlags::CGEventFlagShift);

        // Post the keyboard events
        key_down.post(core_graphics::event::CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(10));
        key_up.post(core_graphics::event::CGEventTapLocation::HID);

        true
    }
}

/// Simulate pressing Cmd+V (paste from clipboard)
/// Used to paste ghost text after clipboard is prepared
pub fn cmd_v() -> bool {
    unsafe {
        let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
            Ok(s) => s,
            Err(_) => {
                eprintln!("❌ Failed to create event source for Cmd+V");
                return false;
            }
        };

        // V key code = 9 on macOS
        let key_down = match CGEvent::new_keyboard_event(source.clone(), 9, true) {
            Ok(e) => e,
            Err(_) => {
                eprintln!("❌ Failed to create V key down event");
                return false;
            }
        };

        let key_up = match CGEvent::new_keyboard_event(source, 9, false) {
            Ok(e) => e,
            Err(_) => {
                eprintln!("❌ Failed to create V key up event");
                return false;
            }
        };

        // Add Command modifier flag
        key_down.set_flags(CGEventFlags::CGEventFlagCommand);
        key_up.set_flags(CGEventFlags::CGEventFlagCommand);

        // Post Cmd+V keyboard events
        key_down.post(core_graphics::event::CGEventTapLocation::HID);
        thread::sleep(Duration::from_millis(10));
        key_up.post(core_graphics::event::CGEventTapLocation::HID);

        true
    }
}
