//
//  SignInView.swift
//  Helio
//
//  Sign in screen for returning users
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var storedProvider: User.AuthProvider?
    @State private var storedEmail: String?

    var body: some View {
        HStack(spacing: 0) {
            // Left Column - Sign in form
            VStack(alignment: .leading, spacing: 24) {
                Spacer()

                // Logo and title
                VStack(alignment: .leading, spacing: 16) {
                    // Helio logo placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("Foreground"))
                        .frame(width: 60, height: 60)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome back!")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(Color("Foreground"))

                        if let email = storedEmail, let provider = storedProvider {
                            Text("You last logged in with \(provider == .apple ? "Apple" : "Email") (\(email))")
                                .font(.system(size: 16))
                                .foregroundColor(Color("MutedForeground"))
                        } else {
                            Text("Sign in to continue with your smart dictation.")
                                .font(.system(size: 16))
                                .foregroundColor(Color("MutedForeground"))
                        }
                    }
                }
                .padding(.bottom, 32)

                // Authentication based on stored provider
                VStack(spacing: 16) {
                    if let provider = storedProvider, provider == .apple {
                        // Show Apple Sign In only
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                handleAppleSignIn(result)
                            }
                        )
                        .frame(height: 50)
                        .signInWithAppleButtonStyle(.black)
                        .cornerRadius(8)

                        // Option to switch account
                        Button(action: {
                            authViewModel.clearAuthData()
                            storedProvider = nil
                            storedEmail = nil
                        }) {
                            Text("Sign in with a different account")
                                .font(.system(size: 14))
                                .foregroundColor(Color("Primary"))
                        }
                        .buttonStyle(PlainButtonStyle())

                    } else if let provider = storedProvider, provider == .email {
                        // Show email/password form
                        VStack(spacing: 12) {
                            // Email input (pre-filled)
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                            // Password input
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                            // Error message
                            if let error = authViewModel.errorMessage {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("Destructive"))
                            }

                            // Sign in button
                            Button(action: handleEmailSignIn) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                } else {
                                    Text("Sign In")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)

                            // Forgot password (stub)
                            Button(action: {}) {
                                Text("Forgot password?")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("Primary"))
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Option to switch account
                            Button(action: {
                                authViewModel.clearAuthData()
                                storedProvider = nil
                                storedEmail = nil
                                email = ""
                            }) {
                                Text("Sign in with a different account")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("Primary"))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }

                    } else {
                        // No stored provider - show all options
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                handleAppleSignIn(result)
                            }
                        )
                        .frame(height: 50)
                        .signInWithAppleButtonStyle(.black)
                        .cornerRadius(8)

                        // Divider
                        HStack {
                            Rectangle()
                                .fill(Color("Border"))
                                .frame(height: 1)
                            Text("or")
                                .font(.system(size: 14))
                                .foregroundColor(Color("MutedForeground"))
                                .padding(.horizontal, 12)
                            Rectangle()
                                .fill(Color("Border"))
                                .frame(height: 1)
                        }

                        // Email sign in
                        VStack(spacing: 12) {
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                            if let error = authViewModel.errorMessage {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("Destructive"))
                            }

                            Button(action: handleEmailSignIn) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                } else {
                                    Text("Sign In")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                        }
                    }
                }

                Spacer()

                // Create account link
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("MutedForeground"))

                    Button(action: {
                        onboardingState.goToStep(.createAccount)
                    }) {
                        Text("Create account")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("Primary"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 96)

            // Right Column - Illustration (same as CreateAccountView)
            VStack {
                Spacer()

                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color("Secondary").opacity(0.3),
                                    Color("Secondary").opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 300, height: 300)

                    Image(systemName: "envelope.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Primary"))
                        .offset(x: -120, y: -80)

                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Primary"))
                        .offset(x: 120, y: 80)

                    Image(systemName: "terminal.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Primary"))
                        .offset(x: 0, y: -140)

                    Image(systemName: "doc.text.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Primary"))
                        .offset(x: 140, y: 0)
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
        .onAppear {
            loadStoredAuthData()
        }
    }

    // MARK: - Actions

    private func loadStoredAuthData() {
        storedProvider = authViewModel.getStoredAuthProvider()
        storedEmail = authViewModel.getStoredEmail()
        if let email = storedEmail {
            self.email = email
        }
    }

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        Task {
            await authViewModel.signInWithApple()
            if authViewModel.currentUser != nil {
                onboardingState.setUser(authViewModel.currentUser!)
                onboardingState.nextStep()
            }
        }
    }

    private func handleEmailSignIn() {
        Task {
            let success = await authViewModel.signInWithEmail(email: email, password: password)
            if success, let user = authViewModel.currentUser {
                onboardingState.setUser(user)
                onboardingState.nextStep()
            }
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(OnboardingState())
        .environmentObject(AuthViewModel())
        .frame(width: 900, height: 600)
}
