// Keyboard simulation using core-graphics (same as ito)
use core_graphics::event::{
    CGEvent, CGEventFlags, CGEventTapLocation, CGKeyCode,
};
use core_graphics::event_source::{CGEventSource, CGEventSourceStateID};
use std::thread;
use std::time::Duration;
use cocoa::base::{id, nil};
use cocoa::foundation::NSString;
use objc::{msg_send, sel, sel_impl, class};
use std::ffi::CStr;

// macOS virtual keycodes (from Carbon Events.h)
const KVK_RETURN: u16 = 0x24; // Return/Enter key
const KVK_ANSI_V: u16 = 0x09; // 'V' key
const KVK_COMMAND: u16 = 0x37; // Command modifier
const KVK_SHIFT: u16 = 0x38; // Shift modifier
const KVK_SPACE: u16 = 0x31; // Space key
const KVK_TAB: u16 = 0x30; // Tab key
const KVK_DELETE: u16 = 0x33; // Backspace/Delete key

// Terminal ghost text delimiter - using Tab for better visibility
const GHOST_TEXT_DELIMITER: &[u8] = b"\t\t"; // Two tabs for clear separation

/// Check if current application is a terminal
pub fn is_terminal() -> bool {
    unsafe {
        let workspace: id = msg_send![class!(NSWorkspace), sharedWorkspace];
        let front_app: id = msg_send![workspace, frontmostApplication];
        if front_app == nil {
            return false;
        }

        let bundle_id: id = msg_send![front_app, bundleIdentifier];
        if bundle_id == nil {
            return false;
        }

        let bundle_str = CStr::from_ptr(NSString::UTF8String(bundle_id));
        match bundle_str.to_str() {
            Ok(id) => {
                // Common terminal bundle IDs
                matches!(id,
                    "com.apple.Terminal" | 
                    "com.googlecode.iterm2" |
                    "dev.warp.Warp-Stable" |
                    "com.github.wez.wezterm" |
                    "co.zeit.hyper" |
                    "com.microsoft.VSCode" // When terminal panel is focused
                )
            }
            Err(_) => false
        }
    }
}

/// Type the ghost text delimiter (two tabs) to separate input from suggestion
pub fn type_delimiter() -> bool {
    let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
        Ok(s) => s,
        Err(_) => {
            eprintln!("Failed to create event source");
            return false;
        }
    };

    // Type two tabs for clear separation
    for _ in 0..2 {
        // Press tab
        let tab_down = match CGEvent::new_keyboard_event(source.clone(), KVK_TAB as CGKeyCode, true) {
            Ok(e) => e,
            Err(_) => {
                eprintln!("Failed to create tab down event");
                return false;
            }
        };
        post_event(&tab_down);

        // Release tab
        let tab_up = match CGEvent::new_keyboard_event(source.clone(), KVK_TAB as CGKeyCode, false) {
            Ok(e) => e,
            Err(_) => {
                eprintln!("Failed to create tab up event");
                return false;
            }
        };
        post_event(&tab_up);
    }

    true
}

/// Post event and add small delay for reliability (20ms recommended for macOS)
fn post_event(event: &CGEvent) {
    event.post(CGEventTapLocation::HID);
    thread::sleep(Duration::from_millis(20));
}

/// Simulate Shift+Enter keypress
/// Returns true on success, false on failure
pub fn shift_enter() -> bool {
    let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
        Ok(s) => s,
        Err(_) => {
            eprintln!("Failed to create event source");
            return false;
        }
    };

    // Create Return key down event with Shift flag
    let return_down = match CGEvent::new_keyboard_event(source.clone(), KVK_RETURN as CGKeyCode, true) {
        Ok(e) => e,
        Err(_) => {
            eprintln!("Failed to create Return down event");
            return false;
        }
    };
    return_down.set_flags(CGEventFlags::CGEventFlagShift);
    return_down.post(CGEventTapLocation::HID);
    thread::sleep(Duration::from_millis(20));  // Delay after posting

    // Create Return key up event with Shift flag
    let return_up = match CGEvent::new_keyboard_event(source, KVK_RETURN as CGKeyCode, false) {
        Ok(e) => e,
        Err(_) => {
            eprintln!("Failed to create Return up event");
            return false;
        }
    };
    return_up.set_flags(CGEventFlags::CGEventFlagShift);
    return_up.post(CGEventTapLocation::HID);
    thread::sleep(Duration::from_millis(20));  // Delay after posting

    true
}

/// Simulate Backspace keypress
/// Returns true on success, false on failure
pub fn backspace() -> bool {
    let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
        Ok(s) => s,
        Err(_) => {
            eprintln!("Failed to create event source");
            return false;
        }
    };

    // Create Delete key down event
    let delete_down = match CGEvent::new_keyboard_event(source.clone(), KVK_DELETE as CGKeyCode, true) {
        Ok(e) => e,
        Err(_) => {
            eprintln!("Failed to create Delete down event");
            return false;
        }
    };
    delete_down.post(CGEventTapLocation::HID);
    thread::sleep(Duration::from_millis(20));  // Delay after posting

    // Create Delete key up event
    let delete_up = match CGEvent::new_keyboard_event(source, KVK_DELETE as CGKeyCode, false) {
        Ok(e) => e,
        Err(_) => {
            eprintln!("Failed to create Delete up event");
            return false;
        }
    };
    delete_up.post(CGEventTapLocation::HID);
    thread::sleep(Duration::from_millis(20));  // Delay after posting

    true
}

