//
//  AuthViewModel.swift
//  Superspeed
//
//  View model for handling authentication logic and UI state
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let authService = AuthService.shared

    init() {
        self.currentUser = authService.currentUser
    }

    // MARK: - Apple Sign In

    func signInWithApple() async {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signInWithApple()
            self.currentUser = user
        } catch {
            self.errorMessage = "Apple Sign In failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - Email Authentication

    func signUpWithEmail(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signUpWithEmail(email: email, password: password)
            self.currentUser = user
            isLoading = false
            return true
        } catch let error as AuthError {
            self.errorMessage = error.errorDescription
            isLoading = false
            return false
        } catch {
            self.errorMessage = "Sign up failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }

    func signInWithEmail(email: String, password: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await authService.signInWithEmail(email: email, password: password)
            self.currentUser = user
            isLoading = false
            return true
        } catch let error as AuthError {
            self.errorMessage = error.errorDescription
            isLoading = false
            return false
        } catch {
            self.errorMessage = "Sign in failed: \(error.localizedDescription)"
            isLoading = false
            return false
        }
    }

    // MARK: - Sign Out

    func signOut() async {
        isLoading = true

        do {
            try await authService.signOut()
            self.currentUser = nil
        } catch {
            self.errorMessage = "Sign out failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    // MARK: - User Metadata

    func updateUserMetadata(referralSource: String? = nil, onboardingCompleted: Bool? = nil) async {
        do {
            try await authService.updateUserMetadata(
                referralSource: referralSource,
                onboardingCompleted: onboardingCompleted
            )
        } catch {
            print("Failed to update user metadata: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper Methods

    func getStoredAuthProvider() -> User.AuthProvider? {
        return authService.getStoredAuthProvider()
    }

    func getStoredEmail() -> String? {
        return authService.getStoredEmail()
    }

    func clearAuthData() {
        authService.clearAuthData()
        currentUser = nil
        errorMessage = nil
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
