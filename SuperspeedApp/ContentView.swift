import SwiftUI
import Cocoa
import CoreGraphics

struct ContentView: View {
    @State private var statusMessage = "Initializing..."
    @State private var isPermissionGranted = false
    @State private var testLog = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Superspeed Text Mode Test")
                .font(.title)

            VStack(alignment: .leading, spacing: 10) {
                Text("Instructions:").bold()
                Text("1. Grant Accessibility + Input Monitoring permissions")
                Text("2. Press Fn key anywhere to toggle text mode")
                Text("3. Start typing in any app (TextEdit, Notes, etc.)")
                Text("4. Stop → Ghost text appears after 3s")
                Text("5. Tab = Accept | Esc = Reject & Regenerate")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            Text(statusMessage)
                .foregroundColor(isPermissionGranted ? .green : .red)
                .bold()

            Button("Check Permissions") {
                checkPermissionsManually()
            }

            Button("Test Toggle (Fn Key)") {
                print("🔵 Manual toggle button pressed (simulating Fn key)")
                SuperspeedTextMode.shared.manualToggle()
            }

            if !testLog.isEmpty {
                Text(testLog)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }

            Text("Check Xcode console for detailed logs →")
                .font(.caption)
                .foregroundColor(.gray)

            .onAppear {
                print("🔵 App launched! ContentView appeared")
                print("🔵 Attempting to start SuperspeedTextMode...")
                checkPermissionsManually()
                setupLocalHotkey()
            }
        }
        .padding()
        .frame(width: 520, height: 500)
    }

    func setupLocalHotkey() {
        // Local event monitor for Fn key (keyCode 63) works when app is focused
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { event in
            // Fn key has keyCode 63
            if event.keyCode == 63 && event.modifierFlags.contains(.function) {
                print("🔵 LOCAL Fn key detected!")
                testLog = "Fn key pressed at \(Date())"
                SuperspeedTextMode.shared.manualToggle()
                return nil // Consume event
            }
            return event
        }
        print("✅ Local Fn key monitor added")
    }

    func checkPermissionsManually() {
        print("🔍 Checking permissions...")
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        let hasPermission = AXIsProcessTrustedWithOptions(options)

        if hasPermission {
            print("✅ Accessibility permission GRANTED")
            statusMessage = "✅ Ready! Press Fn key to start"
            isPermissionGranted = true
            SuperspeedTextMode.shared.start()
        } else {
            print("❌ Accessibility permission DENIED")
            statusMessage = "❌ Need Accessibility permission - Click 'Open System Settings'"
            isPermissionGranted = false
        }
    }
}

// MARK: - Superspeed Text Mode Manager
class SuperspeedTextMode {
    static let shared = SuperspeedTextMode()

    var isActive = false  // Made public for AppDelegate
    private var lastTypingTime: Date?
    private var inactivityTimer: Timer?
    private var keyboardMonitor: CFMachPort?
    private var fnKeyMonitor: Any?
    private var injectedText: String?
    private var lastUserText: String = ""
    private var isGenerating = false // Prevent duplicate injections
    private var lastFnKeyState = false // Debounce Fn key
    
    func start() {
        print("🔵 SuperspeedTextMode.start() called")
        guard checkPermissions() else {
            print("❌ Permissions check failed in start()")
            return
        }
        print("✅ Permissions OK, setting up listeners...")
        setupFnKeyListener()
        print("✅ Superspeed Text Mode ready. Press Fn key to activate.")
    }

    func stop() {
        print("🔴 SuperspeedTextMode.stop() called")
        isActive = false
        stopTypingDetection()
    }

    private func setupFnKeyListener() {
        print("🔧 Setting up Fn key listener (keyCode 63)...")
        // Modern 2025 approach: Use .flagsChanged with keyCode 63 for Fn key
        fnKeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            // Fn key is keyCode 63
            if event.keyCode == 63 && event.modifierFlags.contains(.function) {
                // Only toggle on Fn press (not release) to prevent double-trigger
                if !self.lastFnKeyState {
                    print("🔵 Fn key pressed (global)!")
                    self.toggleTextMode()
                }
                self.lastFnKeyState = true
            } else if event.keyCode == 63 {
                // Fn key released
                self.lastFnKeyState = false
            }
        }
        print("✅ Fn key listener set up")
    }
    
    func manualToggle() {
        print("🔵 manualToggle() called")
        toggleTextMode()
    }

    private func toggleTextMode() {
        isActive.toggle()

        if isActive {
            print("🟢 Text mode ENABLED")
            startTypingDetection()
        } else {
            print("🔴 Text mode DISABLED")
            stopTypingDetection()
        }
    }
    
    private func startTypingDetection() {
        let eventMask = (1 << CGEventType.keyDown.rawValue)
        keyboardMonitor = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { _, _, event, refcon in
                guard let refcon = refcon else { return Unmanaged.passRetained(event) }
                let manager = Unmanaged<SuperspeedTextMode>.fromOpaque(refcon).takeUnretainedValue()
                return manager.onKeyPress(event: event)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )
        
        guard let monitor = keyboardMonitor else {
            print("❌ Failed to create keyboard monitor")
            return
        }
        
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, monitor, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: monitor, enable: true)
        print("👂 Listening for keystrokes...")
    }
    
    private func onKeyPress(event: CGEvent) -> Unmanaged<CGEvent>? {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

        // Handle Tab/Esc if ghost text is active
        if injectedText != nil {
            if keyCode == 48 { // Tab
                print("✅ Ghost text ACCEPTED")
                // Log accept event to database
                if let ghostText = injectedText {
                    DatabaseManager.shared.logInteraction(
                        intent: lastUserText,
                        generatedText: ghostText,
                        action: "accept",
                        appName: getActiveAppName()
                    )
                }
                // Delete user's intent and blank line separator
                deleteUserIntent()
                injectedText = nil
                isGenerating = false
                stopTypingDetection()
                isActive = false
                print("🔴 Text mode DISABLED")
                return nil // Consume the Tab key to prevent actual tab insertion
            } else if keyCode == 53 { // Esc
                print("❌ Ghost text REJECTED. Regenerating...")
                // Log reject event to database
                if let ghostText = injectedText {
                    DatabaseManager.shared.logInteraction(
                        intent: lastUserText,
                        generatedText: ghostText,
                        action: "reject",
                        appName: getActiveAppName()
                    )
                }
                removeInjectedText()
                injectedText = nil
                isGenerating = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    if self.isActive { // Only regenerate if still active
                        self.generateGhostText(isRegeneration: true)
                    }
                }
                return nil // Consume the Esc key
            }
        }

        // User is typing - reset timer
        lastTypingTime = Date()
        inactivityTimer?.invalidate()
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.onTypingPaused()
        }

        return Unmanaged.passRetained(event)
    }
    
    private func onTypingPaused() {
        guard isActive, !isGenerating else { return }
        print("⏸️ User stopped typing. Generating ghost text...")

        if let userText = getCurrentUserText(), !userText.isEmpty {
            lastUserText = userText
            isGenerating = true // Prevent duplicate calls
            generateGhostText(isRegeneration: false)
        }
    }
    
    private func generateGhostText(isRegeneration: Bool) {
        // For Week 1 Part 1: Use DUMMY TEXT (no AI yet)
        let dummyText = isRegeneration
            ? "✨ This is regenerated dummy ghost text! Different version! ⚡"
            : "✨ This is dummy ghost text inserted by Rust! Super fast! ⚡"

        print("📝 User typed: '\(lastUserText)'")
        print("👻 Generating dummy ghost text...")

        self.injectedText = dummyText

        // Call Rust to insert ghost text (Shift+Enter x2, then paste)
        let success = KeyboardBridge.shared.insertGhostText(dummyText)

        if success {
            print("✅ Dummy ghost text inserted via Rust!")
            
            // Rust only does layout now (Shift+Enter x2)
            // Swift handles the actual paste
            injectTextWithClipboard(text: dummyText)
            
            // isGenerating stays true until user accepts/rejects
        } else {
            print("❌ Failed to insert ghost text via Rust")
            self.isGenerating = false
        }
    }
    
    private func deleteUserIntent() {
        // Delete user's original intent text + 2 newlines (blank line separator)
        // According to PRD: move cursor to beginning, select intent+blank line, delete
        let intentLength = lastUserText.count
        let totalCharsToDelete = intentLength + 2  // intent + 2 newlines

        print("🗑️ Deleting user intent (\(intentLength) chars) + blank line...")

        for _ in 0..<totalCharsToDelete {
            simulateBackspace()
            usleep(500)
        }
    }

    private func removeInjectedText() {
        guard let injected = injectedText else { return }
        // +2 to include the two newline characters (blank line separator)
        let totalCharsToDelete = injected.count + 2
        print("🗑️ Deleting ghost text (\(totalCharsToDelete) characters)...")

        // Delete all characters rapidly
        for _ in 0..<totalCharsToDelete {
            simulateBackspace()
            usleep(500) // Small delay for reliability
        }
    }
    
    private func getCurrentUserText() -> String? {
        guard let focused = getFocusedElement() else { return nil }
        var value: AnyObject?
        AXUIElementCopyAttributeValue(focused, kAXValueAttribute as CFString, &value)
        return value as? String
    }
    
    private func stopTypingDetection() {
        if let monitor = keyboardMonitor {
            CGEvent.tapEnable(tap: monitor, enable: false)
            keyboardMonitor = nil
        }
        inactivityTimer?.invalidate()
        injectedText = nil
        isGenerating = false
    }
    
    private func checkPermissions() -> Bool {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        return AXIsProcessTrustedWithOptions(options)
    }

    private func getActiveAppName() -> String? {
        if let activeApp = NSWorkspace.shared.frontmostApplication {
            return activeApp.localizedName
        }
        return nil
    }
}

// MARK: - Network Manager
class NetworkManager {
    static let shared = NetworkManager()

    struct ClaudeAPIResponse: Decodable {
        struct Content: Decodable {
            let text: String
        }
        let content: [Content]
    }

    func getGhostTextFromClaude(prompt: String, completion: @escaping (String?) -> Void) {
        // Get API key from UserDefaults
        let apiKey = UserDefaults.standard.string(forKey: "claudeAPIKey") ?? ""

        guard !apiKey.isEmpty else {
            print("❌ No Claude API key configured. Please add it in Settings.")
            return completion(nil)
        }

        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            return completion(nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        struct APIRequest: Encodable {
            struct Message: Encodable {
                let role: String
                let content: String
            }
            let model: String
            let max_tokens: Int
            let messages: [Message]
        }

        let systemPrompt = """
        You are a professional communication assistant. Rewrite the user's intent into a polished,
        well-formatted message. Keep it concise and natural. Do not add greetings or signatures
        unless the intent suggests them. Match the tone and style to the context.
        """

        let body = APIRequest(
            model: "claude-sonnet-4-20250514",
            max_tokens: 500,
            messages: [.init(role: "user", content: systemPrompt + "\n\nIntent: " + prompt)]
        )

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                return DispatchQueue.main.async { completion(nil) }
            }

            guard let data = data else {
                print("❌ No data received from API")
                return DispatchQueue.main.async { completion(nil) }
            }

            guard let apiResponse = try? JSONDecoder().decode(ClaudeAPIResponse.self, from: data) else {
                print("❌ Failed to decode Claude API response")
                if let rawString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(rawString)")
                }
                return DispatchQueue.main.async { completion(nil) }
            }

            DispatchQueue.main.async {
                completion(apiResponse.content.first?.text)
            }
        }.resume()
    }
}

// MARK: - Helper Functions
func getFocusedElement() -> AXUIElement? {
    var element: AnyObject?
    let result = AXUIElementCopyAttributeValue(AXUIElementCreateSystemWide(), kAXFocusedUIElementAttribute as CFString, &element)

    guard result == .success, let axElement = element else {
        print("⚠️ No focused element found (user might not be in a text field)")
        return nil
    }

    return (axElement as! AXUIElement)
}

func injectTextWithClipboard(text: String) {
    // Based on ITO's proven clipboard paste method
    print("📋 Injecting text via clipboard: '\(text.prefix(50))...'")

    // 1. Save current clipboard
    let savedClipboard = NSPasteboard.general.string(forType: .string)

    // 2. Clear clipboard
    NSPasteboard.general.clearContents()

    // 3. Set new text
    NSPasteboard.general.setString(text, forType: .string)

    // 4. Verify clipboard (retry up to 50 times)
    for _ in 0..<50 {
        if NSPasteboard.general.string(forType: .string) == text {
            break
        }
        Thread.sleep(forTimeInterval: 0.01)
    }

    // 5. Simulate Cmd+V
    let source = CGEventSource(stateID: .hidSystemState)
    let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
    let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)

    keyDown?.flags = .maskCommand
    keyUp?.flags = .maskCommand

    keyDown?.post(tap: .cghidEventTap)
    keyUp?.post(tap: .cghidEventTap)

    // 6. Wait for paste to complete
    Thread.sleep(forTimeInterval: 1.0)

    // 7. Restore original clipboard
    if let saved = savedClipboard {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(saved, forType: .string)
    }

    print("✅ Clipboard paste completed, original clipboard restored")
}

func simulateBackspace() {
    let source = CGEventSource(stateID: .hidSystemState)
    CGEvent(keyboardEventSource: source, virtualKey: 51, keyDown: true)?.post(tap: .cghidEventTap)
    CGEvent(keyboardEventSource: source, virtualKey: 51, keyDown: false)?.post(tap: .cghidEventTap)
}

