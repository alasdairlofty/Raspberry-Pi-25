//
//  AlreadyHaveAccount.swift
//  Rasberry Pie 2025
//
//  Created by Oscar Mason on 29/10/2025.
//

import SwiftUI
import SwiftData
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif
#if canImport(Firebase)
import Firebase
#endif
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

struct SignIntoAccountView: View {
    @State public var emailSignin: String = ""
    @State public var passwordSignin: String = ""
    @State public var passwordConfirmationSignin: String = ""
    @State public var showEmailErrorSignin: Bool = false
    @State public var isLoadingSignin: Bool = false
    @State public var emailIsThereSignin: Bool = false
    @State public var LoggedIn: Bool = false
    @AppStorage("LoggedIn2") var LoggedIn2: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 32)
                
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
                
                
                VStack(spacing: 6) {
                    Text("Sign Into Your Account")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Text("Enter your email to sign in to this app")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 4)
                
                Spacer().frame(height: 20)
                
                
                VStack(spacing: 12) {
                  
                    TextField("Enter your email address", text: $emailSignin, onEditingChanged: { _ in
                        self.showEmailErrorSignin = false
                    })
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(white: 0.9), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(white: 0.98)))
                    )
                    .overlay(
                        Group {
                            if showEmailErrorSignin {
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
                    VStack(spacing: 12) {
                        if !emailSignin.isEmpty {
                            SecureField("Enter your password", text: $passwordSignin)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(white: 0.9), lineWidth: 1)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(white: 0.98)))
                                )
                        }
                    }
                    VStack(spacing: 12) {
                        if !emailSignin.isEmpty && !passwordSignin.isEmpty {
                            SecureField("Confirm your password", text: $passwordConfirmationSignin)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(white: 0.98)))
                                )
                        }
                    }
                    VStack(spacing: 12) {
                        if !emailSignin.isEmpty && !passwordSignin.isEmpty && !passwordConfirmationSignin.isEmpty  {
                            Text("Password must contain 1 uppercase, 1 lowercase, 1 digit")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Text("and 1 symbol and be at least 8 characters long")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    VStack(spacing: 12) {
                        if !emailSignin.isEmpty && !passwordSignin.isEmpty && !passwordConfirmationSignin.isEmpty {
                            Text("By signing in, you agree to our")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                        }
                    }
                    // Continue button
                    Button(action: {
                        attemptContinue()
                    }) {
                        HStack {
                            if isLoadingSignin {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text("Continue")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isLoadingSignin)
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
                        continueWithGoogle()
                    }) {
                        HStack {
                            Image("google_logo")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.leading, 10)
                            Spacer()
                            Text("Continue with Google")
                                .font(.system(size: 15, weight: .medium))
                            Spacer()
                            Color.clear.frame(width: 20)
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
            .navigationDestination(isPresented: $LoggedIn) {
                HomePage()
            }
            .ignoresSafeArea(edges: .bottom)
            .background(Color.white.ignoresSafeArea())
            .onChange(of: emailSignin) { _, newValue in
                emailIsThereSignin = !newValue.isEmpty
            }
            .onOpenURL { url in
                #if canImport(GoogleSignIn)
                _ = GIDSignIn.sharedInstance.handle(url)
                #endif
            }
        }
    }
    
    func attemptContinue() {
        // Validate fields locally first
        guard isValidEmail(emailSignin),
              isValidPassword(passwordSignin),
              passwordSignin == passwordConfirmationSignin
        else {
            showEmailErrorSignin = true
            return
        }

        showEmailErrorSignin = false
        isLoadingSignin = true

        Auth.auth().signIn(withEmail: emailSignin, password: passwordSignin) { authResult, error in
            isLoadingSignin = false

            if let error = error {
                print("Firebase sign in failed: \(error.localizedDescription)")
                showEmailErrorSignin = true
                return
            }

            print("Firebase sign in succeeded for: \(emailSignin)")
            LoggedIn = true
            LoggedIn2 = true
        }
    }
    func continueWithGoogle() {
        #if canImport(GoogleSignIn) && canImport(UIKit)
        guard let rootScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = rootScene.keyWindow?.rootViewController else {
            print("Unable to get rootViewController for Google Sign-In")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Google Sign-In missing tokens")
                return
            }
            let accessToken = user.accessToken.tokenString

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            // Sign in to Firebase with Google credential
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign in with Google failed: \(error.localizedDescription)")
                    return
                }

                // Success: user is now signed in to Firebase using Google
                print("Firebase sign in with Google succeeded for: \(authResult?.user.email ?? "unknown email")")
                
                // Upsert Firestore user document (create if missing, update if exists)
                let db = Firestore.firestore()
                let uid = authResult?.user.uid ?? Auth.auth().currentUser?.uid ?? ""
                if uid.isEmpty {
                    print("Missing uid after Google sign-in")
                    DispatchQueue.main.async {
                        LoggedIn = true
                        LoggedIn2 = true
                    }
                    return
                }

                let docRef = db.collection("users").document(uid)

                // Prefer values from Firebase Auth user; fallback to Google profile if available
                let email = authResult?.user.email
                let displayName = authResult?.user.displayName
                let photoURL = authResult?.user.photoURL?.absoluteString

                var baseData: [String: Any] = [
                    "uid": uid,
                    "provider": "google",
                    "lastSignIn": FieldValue.serverTimestamp()
                ]
                if let email = email { baseData["email"] = email }
                if let displayName = displayName { baseData["displayName"] = displayName }
                if let photoURL = photoURL { baseData["photoURL"] = photoURL }

                // First do a merge write; if the doc doesn't exist it will be created (without createdAt).
                docRef.setData(baseData, merge: true) { setError in
                    if let setError = setError {
                        print("Merge write failed: \(setError.localizedDescription)")
                        DispatchQueue.main.async {
                            LoggedIn = true
                            LoggedIn2 = true
                        }
                        return
                    }

                    // Ensure createdAt is set once, using a transaction that only sets it if absent.
                    db.runTransaction({ (transaction, errorPointer) -> Any? in
                        do {
                            let snapshot = try transaction.getDocument(docRef)
                            if snapshot.exists {
                                if snapshot.get("createdAt") == nil {
                                    transaction.updateData(["createdAt": FieldValue.serverTimestamp()], forDocument: docRef)
                                }
                            } else {
                                var newData = baseData
                                newData["createdAt"] = FieldValue.serverTimestamp()
                                transaction.setData(newData, forDocument: docRef)
                            }
                        } catch {
                            // If we can't read, still proceed—doc already has at least the merge data.
                        }
                        return nil
                    }) { (_, txError) in
                        if let txError = txError {
                            print("Transaction to set createdAt failed: \(txError.localizedDescription)")
                        } else {
                            print("User doc upserted for uid: \(uid)")
                        }
                        DispatchQueue.main.async {
                            LoggedIn = true
                            LoggedIn2 = true
                        }
                    }
                }
                return
            }
        }
        #else
        print("Google Sign-In not available on this platform or GoogleSignIn not linked.")
        #endif
    }

    private func isValidEmail(_ string: String) -> Bool {
        // Very simple regex check (sufficient for UI demo)
        let regex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: string)
    }
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,100}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            .evaluate(with: password)
    }
}

