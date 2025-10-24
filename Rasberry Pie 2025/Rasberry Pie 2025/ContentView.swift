//
//  ContentView.swift
//  Rasberry Pie 2025
//
//  Created by Oscar Mason on 20/10/2025.
//

import SwiftUI
import SwiftData
/*
struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Top-centered logo
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64) // adjust size
                .padding(.top, 12)

            // Main content
            Text("Welcome to Rasberry Pie 2025 SenseCap")
                .foregroundStyle(.secondary)

            Spacer() // pushes content up so the logo stays at top
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // pin stack to top
        .padding(.horizontal)
    }
}
*/

// CreateAccountView.swift
// SenseCap - Signup Screen (SwiftUI)
// Drop an image asset named "sensecap_logo" into Assets.xcassets

import SwiftUI

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var showEmailError: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 32)
            
            // Logo
            Image("sensecap_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 96, height: 96)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(white: 0.98))
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 6)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .accessibilityHidden(true)
            
            Spacer().frame(height: 24)
            
            // Title & subtitle
            VStack(spacing: 6) {
                Text("Create an account")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                Text("Enter your email to sign up for this app")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .padding(.top, 4)
            
            Spacer().frame(height: 20)
            
            // Email field + Continue button
            VStack(spacing: 12) {
                // Email field
                TextField("email@domain.com", text: $email, onEditingChanged: { _ in
                    self.showEmailError = false
                })
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(white: 0.9), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(white: 0.98)))
                )
                .overlay(
                    Group {
                        if showEmailError {
                            HStack {
                                Spacer()
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .padding(.trailing, 12)
                            }
                        } else {
                            EmptyView()
                        }
                    }
                )
                .accessibilityLabel("Email")
                
                // Continue button
                Button(action: {
                    attemptContinue()
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        Text("Continue")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(isLoading)
            }
            .padding(.horizontal, 24)
            .padding(.top, 14)
            
            // OR divider
            HStack(alignment: .center) {
                Capsule()
                    .fill(Color(white: 0.9))
                    .frame(height: 1)
                Text("  or  ")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                Capsule()
                    .fill(Color(white: 0.9))
                    .frame(height: 1)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            
            // Social sign-in buttons
            VStack(spacing: 12) {
                Button(action: {
                    // Google sign-in action
                }) {
                    HStack {
                        Image(systemName: "globe") // placeholder, replace with Google logo asset if you have one
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 10)
                        Spacer()
                        Text("Continue with Google")
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                    }
                    .frame(height: 50)
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button(action: {
                    // Apple sign-in action
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                            .resizable()
                            .frame(width: 18, height: 22)
                            .padding(.leading, 10)
                        Spacer()
                        Text("Continue with Apple")
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                    }
                    .frame(height: 50)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Terms text
            VStack(spacing: 6) {
                Text("By clicking continue, you agree to our Terms of Service and Privacy Policy")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
            }
            .padding(.bottom, 36)
        }
        .ignoresSafeArea(edges: .bottom)
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Actions
    
    private func attemptContinue() {
        // Basic email validation
        if isValidEmail(email) {
            showEmailError = false
            isLoading = true
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isLoading = false
                // proceed to next step (OTP / password / profile)
                // For now, just print
                print("Continue with email: \(email)")
            }
        } else {
            showEmailError = true
        }
    }
    
    private func isValidEmail(_ string: String) -> Bool {
        // Very simple regex check (sufficient for UI demo)
        let regex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: string)
    }
}

// MARK: - Button Styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .shadow(color: Color.black.opacity(configuration.isPressed ? 0.08 : 0.12),
                            radius: configuration.isPressed ? 2 : 6, x: 0, y: 3)
            )
            .scaleEffect(configuration.isPressed ? 0.995 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.primary)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.96))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(white: 0.92), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.995 : 1.0)
    }
}

// MARK: - Preview

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateAccountView()
                .previewDevice("iPhone 14")
            CreateAccountView()
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
