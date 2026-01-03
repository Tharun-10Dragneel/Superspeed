//
//  DashboardView.swift
//  Superspeed
//
//  Main dashboard view after onboarding
//

import SwiftUI

struct DashboardView: View {
    @State private var isSuperspeedActive = false

    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Superspeed Dashboard")
                        .font(.system(size: 32, weight: .bold))

                    Text("Smart dictation for every app")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Status indicator
                HStack(spacing: 8) {
                    Circle()
                        .fill(isSuperspeedActive ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)

                    Text(isSuperspeedActive ? "Active" : "Inactive")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 32)

            Divider()

            // Quick actions
            VStack(spacing: 16) {
                Text("Quick Actions")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 16) {
                    // Toggle button
                    Button(action: {
                        isSuperspeedActive.toggle()
                        // SuperspeedTextMode.shared.manualToggle()
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: isSuperspeedActive ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(isSuperspeedActive ? .orange : .blue)

                            Text(isSuperspeedActive ? "Disable Superspeed" : "Enable Superspeed")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Settings button
                    Button(action: {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.purple)

                            Text("Settings")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 32)

            Divider()

            // Usage stats placeholder
            VStack(spacing: 16) {
                Text("Usage Statistics")
                    .font(.system(size: 20, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("0")
                            .font(.system(size: 36, weight: .bold))
                        Text("Total Suggestions")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("0%")
                            .font(.system(size: 36, weight: .bold))
                        Text("Acceptance Rate")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("0")
                            .font(.system(size: 36, weight: .bold))
                        Text("Time Saved (min)")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            // Instructions
            VStack(spacing: 12) {
                Text("How to use Superspeed")
                    .font(.system(size: 16, weight: .semibold))

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 12) {
                        Text("1.")
                            .fontWeight(.bold)
                        Text("Press Fn key to activate Superspeed")
                    }
                    HStack(alignment: .top, spacing: 12) {
                        Text("2.")
                            .fontWeight(.bold)
                        Text("Type your message in any app")
                    }
                    HStack(alignment: .top, spacing: 12) {
                        Text("3.")
                            .fontWeight(.bold)
                        Text("Wait 3 seconds - ghost text appears")
                    }
                    HStack(alignment: .top, spacing: 12) {
                        Text("4.")
                            .fontWeight(.bold)
                        Text("Tab to accept, Esc to regenerate")
                    }
                }
                .font(.system(size: 14))
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            // isSuperspeedActive = SuperspeedTextMode.shared.isActive
        }
    }
}

#Preview {
    DashboardView()
}
