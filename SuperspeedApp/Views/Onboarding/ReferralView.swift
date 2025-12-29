//
//  ReferralView.swift
//  Helio
//
//  Referral source tracking screen
//

import SwiftUI

struct ReferralView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var selectedSource: String? = nil

    private let referralSources = [
        "Twitter",
        "TikTok",
        "Instagram",
        "Discord",
        "YouTube",
        "Reddit",
        "Friend",
        "Google Search",
        "Product Hunt",
        "Other"
    ]

    var body: some View {
        HStack(spacing: 0) {
            // Left Column
            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                VStack(alignment: .leading, spacing: 32) {
                    // Back button
                    Button(action: {
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

                    // Title
                    VStack(alignment: .leading, spacing: 16) {
                        if let user = authViewModel.currentUser, let firstName = user.firstName {
                            Text("Welcome, \(firstName)!")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(Color("Foreground"))
                        } else {
                            Text("Welcome!")
                                .font(.system(size: 32, weight: .semibold))
                                .foregroundColor(Color("Foreground"))
                        }

                        Text("Where did you hear about us?")
                            .font(.system(size: 16))
                            .foregroundColor(Color("MutedForeground"))
                    }

                    // Dropdown menu
                    Menu {
                        ForEach(referralSources, id: \.self) { source in
                            Button(source) {
                                selectedSource = source
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedSource ?? "Select a source")
                                .font(.system(size: 14))
                                .foregroundColor(selectedSource == nil ? Color("MutedForeground") : Color("Foreground"))

                            Spacer()

                            Image(systemName: "chevron.down")
                                .font(.system(size: 12))
                                .foregroundColor(Color("MutedForeground"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(width: 192)
                        .background(Color("Background"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("Border"), lineWidth: 1)
                        )
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                }

                Spacer()

                // Continue button
                VStack(alignment: .leading) {
                    Button(action: handleContinue) {
                        Text("Continue")
                            .frame(width: 96)
                            .frame(height: 44)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(selectedSource == nil)
                    .opacity(selectedSource == nil ? 0.5 : 1.0)
                }

                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 96)

            // Right Column - Avatar icon placeholder
            VStack {
                Spacer()

                // Large avatar icon
                ZStack {
                    Circle()
                        .fill(Color("Secondary").opacity(0.3))
                        .frame(width: 220, height: 220)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(Color("Primary"))
                        .frame(width: 180, height: 180)
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
    }

    // MARK: - Actions

    private func handleContinue() {
        guard let source = selectedSource else { return }

        onboardingState.setReferralSource(source)
        onboardingState.saveProgress()

        // Update user metadata
        Task {
            await authViewModel.updateUserMetadata(referralSource: source)
        }

        onboardingState.nextStep()
    }
}

#Preview {
    ReferralView()
        .environmentObject(OnboardingState())
        .environmentObject(AuthViewModel())
        .frame(width: 900, height: 600)
}
