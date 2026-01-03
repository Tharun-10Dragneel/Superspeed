//
//  CreateAccountView.swift
//  Superspeed
//
//  First onboarding screen - account creation
//

import SwiftUI
import AuthenticationServices

struct CreateAccountView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showEmailForm: Bool = false

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                // Left Column - Sign up form
                VStack(alignment: .leading, spacing: 24) {
                    Spacer()

                // Logo and title
                VStack(alignment: .leading, spacing: 16) {
                    // Superspeed logo placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("Foreground"))
                        .frame(width: 60, height: 60)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Get started with Superspeed")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundColor(Color("Foreground"))

                        Text("Smart dictation. Everywhere you want.")
                            .font(.system(size: 16))
                            .foregroundColor(Color("MutedForeground"))
                    }
                }
                .padding(.bottom, 32)

                // Authentication options
                VStack(spacing: 16) {
                    // Apple Sign In button
                    SignInWithAppleButton(
                        .signUp,
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

                    // Email/Password form or button
                    if showEmailForm {
                        VStack(spacing: 12) {
                            // Email input
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                            // Password input
                            SecureField("Password (min 8 characters)", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 44)

                            // Error message
                            if let error = authViewModel.errorMessage {
                                Text(error)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("Destructive"))
                            }

                            // Sign up button
                            Button(action: handleEmailSignUp) {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                } else {
                                    Text("Create Account")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .disabled(email.isEmpty || password.count < 8 || authViewModel.isLoading)
                        }
                    } else {
                        Button(action: { showEmailForm = true }) {
                            Text("Continue with Email")
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                        .buttonStyle(OutlineButtonStyle())
                    }
                }

                Spacer()

                // Already have an account
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                        .foregroundColor(Color("MutedForeground"))

                    Button(action: {
                        onboardingState.goToStep(.signIn)
                    }) {
                        Text("Sign in")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("Primary"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Spacer().frame(height: 48)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 96)

            // Right Column - Illustration
            VStack {
                Spacer()

                // Placeholder for app orbit illustration
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

                    // App icons orbiting
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

            // Debug skip button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        onboardingState.completeOnboarding()
                    }) {
                        Text("Skip to Dashboard")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                Spacer()
            }
        }
    }

    // MARK: - Actions

    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        Task {
            await authViewModel.signInWithApple()
            if authViewModel.currentUser != nil {
                onboardingState.setUser(authViewModel.currentUser!)
                onboardingState.nextStep()
            }
        }
    }

    private func handleEmailSignUp() {
        Task {
            let success = await authViewModel.signUpWithEmail(email: email, password: password)
            if success, let user = authViewModel.currentUser {
                onboardingState.setUser(user)
                onboardingState.nextStep()
            }
        }
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color("PrimaryForeground"))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("Primary"))
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Color("Foreground"))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("Border"), lineWidth: 2)
                    .background(Color("Background"))
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

#Preview {
    CreateAccountView()
        .environmentObject(OnboardingState())
        .environmentObject(AuthViewModel())
        .frame(width: 900, height: 600)
}
