//
//  PermissionsView.swift
//  Superspeed
//
//  Accessibility permission request screen
//

import SwiftUI
import ApplicationServices

struct PermissionsView: View {
    @EnvironmentObject var onboardingState: OnboardingState

    @State private var hasAccessibilityPermission: Bool = false
    @State private var isPolling: Bool = false
    @State private var showCheckmark: Bool = false
    @State private var pollingTimer: Timer?

    var body: some View {
        HStack(spacing: 0) {
            // Left Column - Permission request
            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                VStack(alignment: .leading, spacing: 32) {
                    // Back button
                    Button(action: {
                        stopPolling()
                        onboardingState.previousStep()
                    }) {
                        HStack(spacing: 4) {
                            Text("<")
                                .font(.system(size: 16))
                            Text("Back")
                                .font(.system(size: 14))
                        }
                        .foregroundColor(Color("MutedForeground"))
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer().frame(height: 48)

                    // Title - Dynamic based on permission state
                    VStack(alignment: .leading, spacing: 16) {
                        if hasAccessibilityPermission {
                            Text("Thank you for trusting us.")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(Color("Foreground"))

                            Text("We take your privacy seriously.")
                                .font(.system(size: 16))
                                .foregroundColor(Color("MutedForeground"))
                        } else {
                            Text("Set up Superspeed on your computer")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(Color("Foreground"))

                            Text("Grant permission to enable smart text transformation.")
                                .font(.system(size: 16))
                                .foregroundColor(Color("MutedForeground"))
                        }
                    }

                    // Permission Card
                    PermissionCard(
                        title: "Allow Superspeed to insert text",
                        description: "This lets Superspeed put your spoken words in the right textbox and edit text according to your commands",
                        isGranted: hasAccessibilityPermission,
                        isPolling: isPolling,
                        onAllow: requestAccessibilityPermission
                    )
                }

                Spacer()

                // Continue button (only visible when permission granted)
                if hasAccessibilityPermission {
                    VStack(alignment: .leading) {
                        Button(action: handleContinue) {
                            Text("Continue")
                                .frame(width: 96)
                                .frame(height: 44)
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }

                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 96)

            // Right Column - Visual
            VStack {
                Spacer()

                ZStack {
                    if hasAccessibilityPermission && showCheckmark {
                        // Lock icon after permission granted
                        Circle()
                            .fill(Color("Secondary").opacity(0.3))
                            .frame(width: 220, height: 220)

                        Image(systemName: "lock.fill")
                            .resizable()
                            .frame(width: 100, height: 120)
                            .foregroundColor(Color.purple.opacity(0.7))
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Placeholder for permission demo
                        Circle()
                            .fill(Color("Secondary").opacity(0.3))
                            .frame(width: 220, height: 220)

                        Image(systemName: "hand.raised.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color("Primary"))
                    }
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.05),
                        Color.purple.opacity(0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Rectangle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 2),
                alignment: .leading
            )
        }
        .onAppear {
            checkInitialPermission()
        }
        .onDisappear {
            stopPolling()
        }
    }

    // MARK: - Permission Checking

    private func checkInitialPermission() {
        hasAccessibilityPermission = checkAccessibilityPermission()
    }

    private func checkAccessibilityPermission() -> Bool {
        let options: NSDictionary = [
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: false
        ]
        return AXIsProcessTrustedWithOptions(options)
    }

    private func requestAccessibilityPermission() {
        // Trigger the system permission dialog
        let options: NSDictionary = [
            kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true
        ]
        _ = AXIsProcessTrustedWithOptions(options)

        // Start polling to detect when permission is granted
        startPolling()
    }

    // MARK: - Polling

    private func startPolling() {
        isPolling = true

        pollingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            let granted = checkAccessibilityPermission()

            if granted {
                hasAccessibilityPermission = true
                isPolling = false
                stopPolling()

                // Show checkmark animation
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showCheckmark = true
                }

                // Auto-advance after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    handleContinue()
                }
            }
        }
    }

    private func stopPolling() {
        pollingTimer?.invalidate()
        pollingTimer = nil
        isPolling = false
    }

    // MARK: - Actions

    private func handleContinue() {
        onboardingState.nextStep()
    }
}

// MARK: - Permission Card Component

struct PermissionCard: View {
    let title: String
    let description: String
    let isGranted: Bool
    let isPolling: Bool
    let onAllow: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                if isGranted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                        .transition(.scale.combined(with: .opacity))
                }

                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("Foreground"))

                Spacer()

                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 16))
                        .foregroundColor(Color("MutedForeground"))
                }
                .buttonStyle(PlainButtonStyle())
            }

            if !isGranted {
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Color("MutedForeground"))
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: onAllow) {
                    if isPolling {
                        HStack(spacing: 8) {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Checking...")
                                .font(.system(size: 14))
                        }
                        .frame(width: 120, height: 36)
                    } else {
                        Text("Allow")
                            .frame(width: 120, height: 36)
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isPolling)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("Card"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isGranted ? Color.green.opacity(0.5) : Color("Border"), lineWidth: 2)
        )
        .cornerRadius(12)
    }
}

#Preview {
    PermissionsView()
        .environmentObject(OnboardingState())
        .frame(width: 900, height: 600)
}
