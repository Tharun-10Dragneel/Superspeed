//
//  KeyboardBridge.swift
//  Helio
//
//  Swift ↔ Rust FFI Bridge
//


import Foundation
import AppKit
import HelioKeyboard  // from module.modulemap
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
      helio_insert_ghost_text_v2(cstr)
    }

    if !ok {
      // If events were blocked, user likely denied Accessibility
      if !AXIsProcessTrusted() {
        NSLog("Enable Accessibility: System Settings > Privacy & Security > Accessibility")
      }
    }
    return ok
  }
}
