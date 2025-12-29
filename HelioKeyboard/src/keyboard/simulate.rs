// Modern 2025 keyboard simulation using objc2-core-graphics
use objc2_core_graphics::{
    CGEvent, CGEventFlags, CGEventSource, CGEventSourceStateID, CGEventTapLocation,
};
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
    unsafe {
        let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
            Some(s) => s,
            None => {
                eprintln!("Failed to create event source");
                return false;
            }
        };

        // Type two tabs for clear separation
        for _ in 0..2 {
            // Press tab
            let tab_down = match CGEvent::new_keyboard_event(Some(&source), KVK_TAB, true) {
                Some(e) => e,
                None => {
                    eprintln!("Failed to create tab down event");
                    return false;
                }
            };
            post_event(&tab_down);

            // Release tab
            let tab_up = match CGEvent::new_keyboard_event(Some(&source), KVK_TAB, false) {
                Some(e) => e,
                None => {
                    eprintln!("Failed to create tab up event");
                    return false;
                }
            };
            post_event(&tab_up);
        }

        true
    }
}

/// Post event and add small delay for reliability (20ms recommended for macOS)
fn post_event(event: &CGEvent) {
    unsafe {
        CGEvent::post(CGEventTapLocation::HIDEventTap, Some(event));
    }
    thread::sleep(Duration::from_millis(20));
}

/// Simulate Shift+Enter keypress
/// Returns true on success, false on failure
pub fn shift_enter() -> bool {
    unsafe {
        let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
            Some(s) => s,
            None => {
                eprintln!("Failed to create event source");
                return false;
            }
        };

        // Press Shift down
        let shift_down = match CGEvent::new_keyboard_event(Some(&source), KVK_SHIFT, true) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create Shift down event");
                return false;
            }
        };
        post_event(&shift_down);

        // Press Return with Shift flag set
        let return_down = match CGEvent::new_keyboard_event(Some(&source), KVK_RETURN, true) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create Return down event");
                return false;
            }
        };
        CGEvent::set_flags(Some(&return_down), CGEventFlags::MaskShift);
        post_event(&return_down);

        // Release Return
        let return_up = match CGEvent::new_keyboard_event(Some(&source), KVK_RETURN, false) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create Return up event");
                return false;
            }
        };
        CGEvent::set_flags(Some(&return_up), CGEventFlags::MaskShift);
        post_event(&return_up);

        // Release Shift
        let shift_up = match CGEvent::new_keyboard_event(Some(&source), KVK_SHIFT, false) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create Shift up event");
                return false;
            }
        };
        post_event(&shift_up);

        true
    }
}

/// Simulate Cmd+V keypress (paste)
/// Returns true on success, false on failure
pub fn cmd_v() -> bool {
    unsafe {
        let source = match CGEventSource::new(CGEventSourceStateID::CombinedSessionState) {
            Some(s) => s,
            None => {
                eprintln!("Failed to create event source");
                return false;
            }
        };

        // Press Command down
        let cmd_down = match CGEvent::new_keyboard_event(Some(&source), KVK_COMMAND, true) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create Command down event");
                return false;
            }
        };
        post_event(&cmd_down);

        // Press V with Command flag set
        let v_down = match CGEvent::new_keyboard_event(Some(&source), KVK_ANSI_V, true) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create V down event");
                return false;
            }
        };
        CGEvent::set_flags(Some(&v_down), CGEventFlags::MaskCommand);
        post_event(&v_down);

        // Release V
        let v_up = match CGEvent::new_keyboard_event(Some(&source), KVK_ANSI_V, false) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create V up event");
                return false;
            }
        };
        CGEvent::set_flags(Some(&v_up), CGEventFlags::MaskCommand);
        post_event(&v_up);

        // Release Command
        let cmd_up = match CGEvent::new_keyboard_event(Some(&source), KVK_COMMAND, false) {
            Some(e) => e,
            None => {
                eprintln!("Failed to create Command up event");
                return false;
            }
        };
        post_event(&cmd_up);

        true
    }
}
