import SwiftUI

struct SettingsView: View {
    @AppStorage("claudeAPIKey") private var claudeAPIKey = ""
    @AppStorage("pauseDelay") private var pauseDelay = 3.0
    @AppStorage("enableSuperspeed") private var enableSuperspeed = true

    @State private var acceptCount = 0
    @State private var rejectCount = 0
    @State private var showingClearAlert = false

    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Enable Superspeed system-wide", isOn: $enableSuperspeed)
                    .onChange(of: enableSuperspeed) { newValue in
                        if newValue {
                            SuperspeedTextMode.shared.start()
                        } else {
                            SuperspeedTextMode.shared.stop()
                        }
                    }

                HStack {
                    Text("Pause detection delay:")
                    Slider(value: $pauseDelay, in: 1...10, step: 0.5)
                    Text("\(pauseDelay, specifier: "%.1f")s")
                        .frame(width: 40)
                }
            }

            Section(header: Text("AI Settings")) {
                SecureField("Claude API Key", text: $claudeAPIKey)
                    .textFieldStyle(.roundedBorder)

                Text("Get your API key from: console.anthropic.com")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section(header: Text("Statistics")) {
                HStack {
                    Text("Accepts:")
                    Spacer()
                    Text("\(acceptCount)")
                        .foregroundColor(.green)
                }

                HStack {
                    Text("Rejects:")
                    Spacer()
                    Text("\(rejectCount)")
                        .foregroundColor(.red)
                }

                HStack {
                    Text("Accept Rate:")
                    Spacer()
                    Text(acceptRate)
                        .foregroundColor(.blue)
                }

                Button("Refresh Stats") {
                    loadStats()
                }
            }

            Section(header: Text("Usage")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Press Fn once to activate Superspeed")
                    Text("• Type your intent in any app")
                    Text("• Wait 3 seconds → Ghost text appears")
                    Text("• Tab = Accept | Esc = Reject & Regenerate")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Section(header: Text("Advanced")) {
                Button("Clear All Learning Data") {
                    showingClearAlert = true
                }
                .foregroundColor(.red)
                .alert("Clear All Data?", isPresented: $showingClearAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Clear", role: .destructive) {
                        DatabaseManager.shared.clearAllData()
                        loadStats()
                    }
                } message: {
                    Text("This will delete all logged interactions and learning data. This cannot be undone.")
                }
            }
        }
        .padding(20)
        .frame(width: 550, height: 550)
        .onAppear {
            loadStats()
        }
    }

    private func loadStats() {
        let stats = DatabaseManager.shared.getAcceptRejectCounts()
        acceptCount = stats.accepts
        rejectCount = stats.rejects
    }

    private var acceptRate: String {
        let total = acceptCount + rejectCount
        guard total > 0 else { return "N/A" }
        let rate = Double(acceptCount) / Double(total) * 100
        return String(format: "%.1f%%", rate)
    }
}
