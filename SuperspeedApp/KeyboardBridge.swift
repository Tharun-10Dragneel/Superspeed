//
//  KeyboardBridge.swift
//  Superspeed
//
//  Swift ↔ Rust FFI Bridge
//


import Foundation
import AppKit
import SuperspeedKeyboard  // from module.modulemap
import ApplicationServices // for AX APIs

final class KeyboardBridge {
  static let shared = KeyboardBridge()
  private init() {}

  // Optional: prompt for Accessibility if not trusted
  private func ensureAccessibility() {
    let opts: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
    _ = AXIsProcessTrustedWithOptions(opts) // prompts if needed
  }

  @discardableResult
  func insertGhostText(_ text: String) -> Bool {
    precondition(Thread.isMainThread, "Call on main thread for NSPasteboard safety")

    ensureAccessibility()

    let ok = text.withCString { cstr in
      superspeed_insert_ghost_text_v2(cstr)
    }

    if !ok {
      // If events were blocked, user likely denied Accessibility
      if !AXIsProcessTrusted() {
        NSLog("Enable Accessibility: System Settings > Privacy & Security > Accessibility")
      }
    }
    return ok
  }

  /// Read N characters before cursor using clipboard trick
  /// Returns the text before cursor, or nil on error
  func readCursorContext(charCount: Int) -> String? {
    precondition(Thread.isMainThread, "Call on main thread for NSPasteboard safety")
    precondition(charCount > 0, "charCount must be positive")

    ensureAccessibility()

    // Call Rust FFI function
    let cStringPtr = superspeed_read_cursor_context(charCount)

    // Check for null pointer (error)
    guard cStringPtr != nil else {
      NSLog("❌ Failed to read cursor context (null pointer returned)")
      return nil
    }

    // Convert C string to Swift String
    let text = String(cString: cStringPtr!)

    // Free the C string memory (IMPORTANT!)
    superspeed_free_string(cStringPtr)

    return text
  }
}
