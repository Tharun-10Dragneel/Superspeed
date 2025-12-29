//
//  OnboardingState.swift
//  Superspeed
//
//  Manages the onboarding flow state and navigation
//

import Foundation
import SwiftUI

class OnboardingState: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var isCompleted: Bool = false
    @Published var user: User? = nil
    @Published var referralSource: String? = nil

    enum Step: Int, CaseIterable {
        case createAccount = 0
        case signIn = 1
        case referral = 2
        case permissions = 3
        case goodToGo = 4
        case tryItOut = 5

        var title: String {
            switch self {
            case .createAccount: return "Create Account"
            case .signIn: return "Sign In"
            case .referral: return "Referral"
            case .permissions: return "Permissions"
            case .goodToGo: return "Good To Go"
            case .tryItOut: return "Try It Out"
            }
        }
    }

    // MARK: - Navigation

    func nextStep() {
        if currentStep < Step.allCases.count - 1 {
            currentStep += 1
        }
    }

    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    func goToStep(_ step: Step) {
        currentStep = step.rawValue
    }

    func completeOnboarding() {
        isCompleted = true
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
    }

    // MARK: - User Data

    func setUser(_ user: User) {
        self.user = user
    }

    func setReferralSource(_ source: String) {
        self.referralSource = source
    }

    // MARK: - Persistence

    func saveProgress() {
        UserDefaults.standard.set(currentStep, forKey: "onboardingCurrentStep")
        if let referralSource = referralSource {
            UserDefaults.standard.set(referralSource, forKey: "referralSource")
        }
    }

    func loadProgress() {
        currentStep = UserDefaults.standard.integer(forKey: "onboardingCurrentStep")
        referralSource = UserDefaults.standard.string(forKey: "referralSource")
        isCompleted = UserDefaults.standard.bool(forKey: "onboardingCompleted")
    }

    func resetOnboarding() {
        currentStep = 0
        isCompleted = false
        user = nil
        referralSource = nil
        UserDefaults.standard.removeObject(forKey: "onboardingCompleted")
        UserDefaults.standard.removeObject(forKey: "onboardingCurrentStep")
        UserDefaults.standard.removeObject(forKey: "referralSource")
    }
}
