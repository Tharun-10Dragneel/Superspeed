//
//  AuthService.swift
//  Helio
//
//  Simplified authentication service interface
//

import Foundation
import AuthenticationServices

class AuthService: NSObject, ObservableObject {
    static let shared = AuthService()

    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false

    private override init() {
        super.init()
        loadCurrentUser()
    }

    // MARK: - Authentication Methods

    /// Sign in with Apple
    func signInWithApple() async throws -> User {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        // TODO: Implement actual Apple Sign In flow
        // For now, create a mock user for testing
        let user = User(
            id: UUID().uuidString,
            email: "apple.user@example.com",
            name: "Apple User",
            provider: .apple
        )

        user.save()
        self.currentUser = user
        self.isAuthenticated = true

        return user
    }

    /// Sign up with email and password
    func signUpWithEmail(email: String, password: String) async throws -> User {
        // Validate email format
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        // Validate password strength
        guard password.count >= 8 else {
            throw AuthError.weakPassword
        }

        // Use Supabase service for actual signup
        let user = try await SupabaseService.shared.signUpWithEmail(
            email: email,
            password: password
        )

        self.currentUser = user
        self.isAuthenticated = true

        return user
    }

    /// Sign in with email and password
    func signInWithEmail(email: String, password: String) async throws -> User {
        // Validate email format
        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        // Use Supabase service for actual sign in
        let user = try await SupabaseService.shared.signInWithEmail(
            email: email,
            password: password
        )

        self.currentUser = user
        self.isAuthenticated = true

        return user
    }

    /// Sign out current user
    func signOut() async throws {
        try await SupabaseService.shared.signOut()
        self.currentUser = nil
        self.isAuthenticated = false
    }

    /// Update user metadata
    func updateUserMetadata(referralSource: String? = nil, onboardingCompleted: Bool? = nil) async throws {
        guard let user = currentUser else { return }

        var metadata: [String: Any] = [:]
        if let source = referralSource {
            metadata["referral_source"] = source
        }
        if let completed = onboardingCompleted {
            metadata["onboarding_completed"] = completed
        }

        try await SupabaseService.shared.updateUserMetadata(
            userId: user.id,
            metadata: metadata
        )
    }

    // MARK: - Helper Methods

    private func loadCurrentUser() {
        self.currentUser = User.load()
        self.isAuthenticated = currentUser != nil
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    /// Get stored auth provider
    func getStoredAuthProvider() -> User.AuthProvider? {
        guard let providerString = UserDefaults.standard.string(forKey: "authProvider") else {
            return nil
        }
        return User.AuthProvider(rawValue: providerString)
    }

    /// Get stored email
    func getStoredEmail() -> String? {
        return UserDefaults.standard.string(forKey: "userEmail")
    }

    /// Clear stored auth data
    func clearAuthData() {
        User.clear()
        currentUser = nil
        isAuthenticated = false
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case userNotFound
    case wrongPassword
    case emailAlreadyExists
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 8 characters"
        case .userNotFound:
            return "No account found with this email"
        case .wrongPassword:
            return "Incorrect password"
        case .emailAlreadyExists:
            return "An account with this email already exists"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
