//
//  KeyboardBridge.swift
//  Superspeed
//
//  Swift ↔ Rust FFI Bridge
//

import Foundation

// Declare Rust function (C ABI)
@_silgen_name("superspeed_insert_ghost_text")
private func _rust_insert_ghost_text(_: UnsafePointer<CChar>) -> Bool

/// Swift wrapper for Rust keyboard simulation functions
class KeyboardBridge {
    static let shared = KeyboardBridge()

    private init() {}

    /// Insert ghost text using Rust keyboard simulation
    /// - Parameter text: The text to insert
    /// - Returns: true if successful, false otherwise
    func insertGhostText(_ text: String) -> Bool {
        print("🌉 Swift bridge calling Rust with text: \(text)")

        let success = text.withCString { cString in
            _rust_insert_ghost_text(cString)
        }

        if success {
            print("✅ Swift bridge: Rust returned success")
        } else {
            print("❌ Swift bridge: Rust returned failure")
        }

        return success
    }
}
