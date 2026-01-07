//
//  SuperspeedApp.swift
//  Superspeed
//
//  Created by hak on 04/10/25.
//

import SwiftUI

@main
struct SuperspeedApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("onboardingCompleted") var onboardingCompleted: Bool = false

    var body: some Scene {
        // Main window
        WindowGroup("Superspeed") {
            if !onboardingCompleted {
                OnboardingCoordinator()
                    .frame(minWidth: 900, minHeight: 600)
                    .frame(maxWidth: 900, maxHeight: 600)
            } else {
                DashboardView()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }

        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Check if onboarding is needed
        let onboardingCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")

        if !onboardingCompleted {
            // Show as regular app for onboarding
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            // Run as background accessory app (no Dock icon, doesn't steal focus)
            NSApp.setActivationPolicy(.accessory)
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sun.max.fill", accessibilityDescription: "Superspeed")
            button.image?.isTemplate = true
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Enable Superspeed", action: #selector(toggleSuperspeed), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Superspeed", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu

        // Start SuperspeedTextMode (always available, user toggles with Fn key)
        SuperspeedTextMode.shared.start()
    }

    @objc func toggleSuperspeed() {
        SuperspeedTextMode.shared.manualToggle()
        updateMenuText()
    }

    @objc func openSettings() {
        // Temporarily switch to regular to show settings window
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)

        // Switch back to accessory when window closes (will be handled by window delegate)
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }

    func updateMenuText() {
        if let menu = statusItem?.menu,
           let item = menu.item(at: 0) {
            item.title = SuperspeedTextMode.shared.isActive ? "Disable Superspeed" : "Enable Superspeed"
        }
    }
}



