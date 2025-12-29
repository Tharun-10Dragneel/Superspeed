//
//  GoodToGoView.swift
//  Superspeed
//
//  Setup completion confirmation screen
//

import SwiftUI

struct GoodToGoView: View {
    @EnvironmentObject var onboardingState: OnboardingState

    var body: some View {
        HStack(spacing: 0) {
            // Left Column - Success message
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

                    // Title and message
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your hardware setup is good to go!")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(Color("Foreground"))
                            .fixedSize(horizontal: false, vertical: true)

                        Text("You're all set! Superspeed has the permissions it needs to transform your typing and speech into polished output.")
                            .font(.system(size: 16))
                            .foregroundColor(Color("MutedForeground"))
                            .fixedSize(horizontal: false, vertical: true)
                    }
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
                }

                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 96)

            // Right Column - Success checkmark icon
            VStack {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color("Secondary").opacity(0.3))
                        .frame(width: 220, height: 220)

                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(Color.purple.opacity(0.7))
                        .frame(width: 180, height: 180)
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: true)

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
        onboardingState.nextStep()
    }
}

#Preview {
    GoodToGoView()
        .environmentObject(OnboardingState())
        .frame(width: 900, height: 600)
}
