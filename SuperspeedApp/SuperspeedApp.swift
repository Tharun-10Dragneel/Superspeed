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
    @AppStorage("onboardingCompleted") var onboardingCompleted: Bool = false

    var body: some Scene {
        // Onboarding window (shown only when onboarding not completed)
        WindowGroup("Helio Onboarding") {
            if !onboardingCompleted {
                OnboardingCoordinator()
                    .frame(minWidth: 900, minHeight: 600)
                    .frame(maxWidth: 900, maxHeight: 600)
            } else {
                // Show empty view if onboarding is completed
                // Main app is menu bar only
                EmptyView()
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
        // Check if onboarding is completed
        let onboardingCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")

        if !onboardingCompleted {
            // Show onboarding window on first launch
            NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            // Set as accessory app (menu bar only)
            NSApp.setActivationPolicy(.accessory)
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "sun.max.fill", accessibilityDescription: "Helio")
            button.image?.isTemplate = true
        }

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Enable Helio", action: #selector(toggleHelio), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Helio", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu

        // Only start Helio if onboarding is completed
        if onboardingCompleted {
            HelioTextMode.shared.start()
        }
    }

    @objc func toggleHelio() {
        HelioTextMode.shared.manualToggle()
        updateMenuText()
    }

    @objc func openSettings() {

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
