//
//  OnboardingCoordinator.swift
//  Helio
//
//  Main coordinator for the onboarding flow - manages navigation between screens
//

import SwiftUI

struct OnboardingCoordinator: View {
    @StateObject private var onboardingState = OnboardingState()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()

            // Main content based on current step
            Group {
                switch onboardingState.currentStep {
                case OnboardingState.Step.createAccount.rawValue:
                    CreateAccountView()
                case OnboardingState.Step.signIn.rawValue:
                    SignInView()
                case OnboardingState.Step.referral.rawValue:
                    ReferralView()
                case OnboardingState.Step.permissions.rawValue:
                    PermissionsView()
                case OnboardingState.Step.goodToGo.rawValue:
                    GoodToGoView()
                case OnboardingState.Step.tryItOut.rawValue:
                    TryItOutView()
                default:
                    CreateAccountView()
                }
            }
        }
        .environmentObject(onboardingState)
        .environmentObject(authViewModel)
        .frame(minWidth: 900, minHeight: 600)
        .onAppear {
            onboardingState.loadProgress()
        }
    }
}

#Preview {
    OnboardingCoordinator()
}
