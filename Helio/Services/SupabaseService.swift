//
//  SupabaseService.swift
//  Helio
//
//  Supabase client wrapper for authentication and database operations
//  NOTE: Requires Supabase Swift SDK to be added via SPM
//

import Foundation

class SupabaseService {
    static let shared = SupabaseService()

    // MARK: - Configuration

    private let supabaseURL: String
    private let supabaseAnonKey: String
    private var isConfigured: Bool = false

    // TODO: Replace with your actual Supabase credentials
    // Get these from https://supabase.com after creating a project
    private init() {
        // Load from environment or config file
        self.supabaseURL = UserDefaults.standard.string(forKey: "supabaseURL") ?? ""
        self.supabaseAnonKey = UserDefaults.standard.string(forKey: "supabaseAnonKey") ?? ""
        self.isConfigured = !supabaseURL.isEmpty && !supabaseAnonKey.isEmpty
    }

    // MARK: - Configuration Methods

    func configure(url: String, anonKey: String) {
        UserDefaults.standard.set(url, forKey: "supabaseURL")
        UserDefaults.standard.set(anonKey, forKey: "supabaseAnonKey")
        self.isConfigured = true
    }

    func isSupabaseConfigured() -> Bool {
        return isConfigured
    }

    // MARK: - Authentication Methods

    /// Sign in with Apple ID token
    /// - Parameter idToken: Apple ID token from successful Sign in with Apple
    /// - Returns: User object if successful
    func signInWithApple(idToken: String) async throws -> User {
        // TODO: Implement actual Supabase Apple Sign In
        // For now, create a mock user
        let user = User(
            id: UUID().uuidString,
            email: "user@apple.com",
            name: "Apple User",
            provider: .apple
        )
        user.save()
        return user
    }

    /// Sign up with email and password
    func signUpWithEmail(email: String, password: String) async throws -> User {
        // TODO: Implement actual Supabase email signup
        // For now, create a mock user
        let user = User(
            id: UUID().uuidString,
            email: email,
            name: email.components(separatedBy: "@").first,
            provider: .email
        )
        user.save()
        return user
    }

    /// Sign in with email and password
    func signInWithEmail(email: String, password: String) async throws -> User {
        // TODO: Implement actual Supabase email sign in
        // For now, return saved user or create new one
        if let savedUser = User.load(), savedUser.email == email {
            return savedUser
        }
        let user = User(
            id: UUID().uuidString,
            email: email,
            name: email.components(separatedBy: "@").first,
            provider: .email
        )
        user.save()
        return user
    }

    /// Sign out current user
    func signOut() async throws {
        // TODO: Implement actual Supabase sign out
        User.clear()
    }

    /// Get current session
    func getCurrentUser() async throws -> User? {
        // TODO: Implement actual Supabase session check
        return User.load()
    }

    // MARK: - User Metadata Methods

    /// Update user metadata (referral source, etc.)
    func updateUserMetadata(userId: String, metadata: [String: Any]) async throws {
        // TODO: Implement actual Supabase metadata update
        if var user = User.load() {
            let newMetadata = User.UserMetadata(
                referralSource: metadata["referral_source"] as? String,
                onboardingCompleted: metadata["onboarding_completed"] as? Bool
            )
            user = User(
                id: user.id,
                email: user.email,
                name: user.name,
                provider: user.provider,
                createdAt: user.createdAt,
                metadata: newMetadata
            )
            user.save()
        }
    }
}

// MARK: - Supabase Installation Instructions

/*
 To use Supabase authentication:

 1. Install Supabase Swift SDK via Swift Package Manager:
    - File → Add Package Dependencies
    - URL: https://github.com/supabase-community/supabase-swift
    - Version: Latest (2.x.x)

 2. Create a Supabase project at https://supabase.com

 3. Get your project URL and anon key from:
    Project Settings → API → Project URL and anon/public key

 4. Configure the service:
    SupabaseService.shared.configure(
        url: "YOUR_PROJECT_URL",
        anonKey: "YOUR_ANON_KEY"
    )

 5. Uncomment and implement the Supabase client initialization above

 6. Enable authentication providers in Supabase:
    - Authentication → Providers → Enable Apple/Email
    - For Apple: Configure Apple Developer Service ID
*/
