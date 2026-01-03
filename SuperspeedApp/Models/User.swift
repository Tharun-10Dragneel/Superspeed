//
//  User.swift
//  Superspeed
//
//  User model representing an authenticated user
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String?
    let name: String?
    let provider: AuthProvider
    let createdAt: Date
    let metadata: UserMetadata?

    enum AuthProvider: String, Codable {
        case apple = "apple"
        case email = "email"
        case google = "google"
        case unknown = "unknown"
    }

    struct UserMetadata: Codable {
        let referralSource: String?
        let onboardingCompleted: Bool?

        enum CodingKeys: String, CodingKey {
            case referralSource = "referral_source"
            case onboardingCompleted = "onboarding_completed"
        }
    }

    // MARK: - Computed Properties

    var firstName: String? {
        guard let name = name else { return nil }
        return name.components(separatedBy: " ").first
    }

    var initials: String {
        if let name = name {
            let components = name.components(separatedBy: " ")
            let initials = components.compactMap { $0.first }.prefix(2)
            return String(initials).uppercased()
        }
        if let email = email {
            return String(email.prefix(2)).uppercased()
        }
        return "U"
    }

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case provider
        case createdAt = "created_at"
        case metadata
    }

    // MARK: - Initialization

    init(
        id: String,
        email: String?,
        name: String?,
        provider: AuthProvider,
        createdAt: Date = Date(),
        metadata: UserMetadata? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.provider = provider
        self.createdAt = createdAt
        self.metadata = metadata
    }

    // MARK: - Persistence

    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(provider.rawValue, forKey: "authProvider")
        }
    }

    static func load() -> User? {
        guard let data = UserDefaults.standard.data(forKey: "currentUser"),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "authProvider")
    }
}
