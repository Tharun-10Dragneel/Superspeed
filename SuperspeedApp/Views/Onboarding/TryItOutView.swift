//
//  TryItOutView.swift
//  Superspeed
//
//  Interactive demo screen (placeholder - to be designed by user)
//

import SwiftUI

struct TryItOutView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        HStack(spacing: 0) {
            // Left Column - Demo content
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

                    // Title and placeholder message
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Try it out")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(Color("Foreground"))

                        Text("Interactive demo coming soon - you'll design this yourself")
                            .font(.system(size: 16))
                            .foregroundColor(Color("MutedForeground"))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Placeholder content area
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Future features:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color("Foreground"))

                        VStack(alignment: .leading, spacing: 8) {
                            DemoFeatureItem(text: "Demo textbox to type/speak into")
                            DemoFeatureItem(text: "Ghost text preview demonstration")
                            DemoFeatureItem(text: "Tab/Esc instruction overlay")
                            DemoFeatureItem(text: "Example transformations")
                        }
                    }
                    .padding(20)
                    .background(Color("Card"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("Border"), lineWidth: 2)
                    )
                    .cornerRadius(12)
                }

                Spacer()

                // Finish button
                VStack(alignment: .leading) {
                    Button(action: handleFinish) {
                        Text("Finish")
                            .frame(width: 96)
                            .frame(height: 44)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }

                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 96)

            // Right Column - Placeholder illustration
            VStack {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color("Secondary").opacity(0.3))
                        .frame(width: 220, height: 220)

                    Image(systemName: "text.cursor")
                        .resizable()
                        .frame(width: 80, height: 100)
                        .foregroundColor(Color("Primary"))
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

    private func handleFinish() {
        // Update user metadata to mark onboarding as completed
        Task {
            await authViewModel.updateUserMetadata(onboardingCompleted: true)
        }

        // Complete onboarding (this will save progress and navigate to main app)
        onboardingState.completeOnboarding()
        onboardingState.saveProgress()
    }
}

// MARK: - Demo Feature Item Component

struct DemoFeatureItem: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
                .foregroundColor(Color("MutedForeground"))

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color("MutedForeground"))
        }
    }
}

#Preview {
    TryItOutView()
        .environmentObject(OnboardingState())
        .environmentObject(AuthViewModel())
        .frame(width: 900, height: 600)
}
