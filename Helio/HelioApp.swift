//
//  HelioApp.swift
//  Helio
//
//  Created by hak on 04/10/25.
//

import SwiftUI

@main
struct HelioApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon and main window
        NSApp.setActivationPolicy(.accessory)

        // Create menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sun.max.fill", accessibilityDescription: "Helio")
            button.image?.isTemplate = true
        }

        // Create menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Enable Helio", action: #selector(toggleHelio), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Helio", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu

        // Start Helio in background
        print("🔵 Helio app launched")
        HelioTextMode.shared.start()
    }

    @objc func toggleHelio() {
        HelioTextMode.shared.manualToggle()
        updateMenuText()
    }

    @objc func openSettings() {
        // Open settings window
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    func updateMenuText() {
        if let menu = statusItem?.menu,
           let item = menu.item(at: 0) {
            item.title = HelioTextMode.shared.isActive ? "Disable Helio" : "Enable Helio"
        }
    }
}
