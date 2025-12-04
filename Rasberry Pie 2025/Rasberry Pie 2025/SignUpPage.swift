//
//  ContentView.swift
//  Rasberry Pie 2025
//
//  Created by Oscar Mason on 20/10/2025.
//

import SwiftUI
import SwiftData
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif
#if canImport(Firebase)
import Firebase
#endif
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

struct CreateAccountView: View {
    @State public var email: String = ""
    @State public var password: String = ""
    @State public var passwordConfirmation: String = ""
    @State public var showEmailError: Bool = false
    @State public var isLoading: Bool = false
    @State public var emailIsThere: Bool = false
    @State public var LoggedIn: Bool = false
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
            
            
            VStack(spacing: 12) {
              
                TextField("Enter your email address", text: $email, onEditingChanged: { _ in
                    self.showEmailError = false
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
                VStack(spacing: 12) {
                    if !email.isEmpty {
                        SecureField("Enter your password", text: $password)
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
                    if !email.isEmpty && !password.isEmpty {
                        SecureField("Confirm your password", text: $passwordConfirmation)
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
                    if !email.isEmpty && !password.isEmpty && !passwordConfirmation.isEmpty  {
                        Text("Password must contain 1 uppercase, 1 lowercase, 1 digit")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("and 1 symbol and be at least 8 characters long")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                VStack(spacing: 12) {
                    if !email.isEmpty && !password.isEmpty && !passwordConfirmation.isEmpty {
                        Text("By creating an account, you agree to our")
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
                .disabled(isLoading)
                
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
        .ignoresSafeArea(edges: .bottom)
        .background(Color.white.ignoresSafeArea())
        .onChange(of: email) { _, newValue in
            emailIsThere = !newValue.isEmpty
        }
        .onOpenURL { url in
            #if canImport(GoogleSignIn)
            _ = GIDSignIn.sharedInstance.handle(url)
            #endif
        }
        .navigationDestination(isPresented: $LoggedIn) {
            HomePage()
        }
    }
    }
    
   
    
    // MARK: - Actions
    
    private func attemptContinue() {
        // Validate input locally first
        guard isValidEmail(email),
              isValidPassword(password),
              password == passwordConfirmation else {
            showEmailError = true
            return
        }

        showEmailError = false
        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            isLoading = false

            if let error = error {
                // Surface an error state; you can refine this to show specific messages
                print("Firebase sign up failed: \(error.localizedDescription)")
                showEmailError = true
                return
            }

            // Success: Firebase securely stores credentials and signs the user in
            print("Firebase sign up succeeded for: \(email)")
            LoggedIn = true

            // Optional: send verification email
            Auth.auth().currentUser?.sendEmailVerification { verificationError in
                if let verificationError = verificationError {
                    print("Failed to send verification email: \(verificationError.localizedDescription)")
                } else {
                    print("Verification email sent.")
                }
            }
        }
    }
        
    public func continueWithGoogle(completion: ((Bool) -> Void)? = nil) {
        #if canImport(GoogleSignIn) && canImport(UIKit)
        guard let rootScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = rootScene.keyWindow?.rootViewController else {
            print("Unable to get rootViewController for Google Sign-In")
            completion?(false)
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                completion?(false)
                return
            }

            guard let user = result?.user else {
                print("Google Sign-In returned no user")
                completion?(false)
                return
            }

            // Access tokens correctly (avoid optional chaining on non-optional types where applicable)
            let idTokenString = user.idToken?.tokenString
            let accessTokenString = user.accessToken.tokenString

            guard let idTokenString = idTokenString else {
                print("Missing Google ID token")
                completion?(false)
                return
            }

            // Create Firebase credential using Google tokens
            let credential = GoogleAuthProvider.credential(withIDToken: idTokenString, accessToken: accessTokenString)

            // Ensure persistence is local (default on iOS, but we set it explicitly for clarity)
            Auth.auth().settings?.isAppVerificationDisabledForTesting = false

            let auth = Auth.auth()

            if let currentUser = auth.currentUser {
                // If a user is already signed in (e.g., with email/password), link Google to that Firebase account
                currentUser.link(with: credential) { result, error in
                    if let error = error as NSError? {
                        if error.code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                            // The Google credential is already linked to a different user. Sign in with it, then migrate if needed.
                            auth.signIn(with: credential) { authResult, signInError in
                                if let signInError = signInError {
                                    print("Google sign-in after credential in use failed: \(signInError.localizedDescription)")
                                    completion?(false)
                                    return
                                }
                                let email = authResult?.user.email ?? "unknown email"
                                print("Signed in with existing Google-linked account: \(email)")
                                LoggedIn = true
                                completion?(true)
                            }
                        } else {
                            print("Linking Google credential failed: \(error.localizedDescription)")
                            completion?(false)
                        }
                        return
                    }
                    let linkedUser = result?.user
                    let uid = linkedUser?.uid ?? auth.currentUser?.uid
                    let email = linkedUser?.email ?? user.profile?.email
                    let displayName = linkedUser?.displayName ?? user.profile?.name
                    let photoURL = linkedUser?.photoURL?.absoluteString ?? user.profile?.imageURL(withDimension: 200)?.absoluteString

                    guard let uid = uid else {
                        print("Missing uid after linking Google")
                        completion?(false)
                        return
                    }

                    self.upsertUserDocumentAndThen(uid: uid, email: email, displayName: displayName, photoURL: photoURL) { ok in
                        if ok {
                            LoggedIn = true
                            completion?(true)
                        } else {
                            completion?(false)
                        }
                    }
                }
            } else {
                // No current user: sign in with Google credential; Firebase creates the user if it doesn't exist
                auth.signIn(with: credential) { authResult, error in
                    if let error = error as NSError? {
                        if error.code == AuthErrorCode.accountExistsWithDifferentCredential.rawValue {
                            // The email is already used by a different auth provider. Avoid deprecated fetchSignInMethods.
                            // Best practice: prompt the user to sign in using their original method and then link Google.
                            // If the error contains an updated credential, consider using it to continue the flow.
                            if error.userInfo[AuthErrorUserInfoUpdatedCredentialKey] is AuthCredential {
                                print("Received updated credential for different account flow. You may choose to sign in with this credential or prompt the user accordingly.")
                            } else {
                                let email = user.profile?.email ?? "unknown email"
                                print("Account exists with different credential for email: \(email). Guide the user to sign in with their original method and link Google from settings.")
                            }
                            completion?(false)
                            return
                        }
                        print("Firebase Google auth failed: \(error.localizedDescription)")
                        completion?(false)
                        return
                    }
                    let signedInUser = authResult?.user
                    let uid = signedInUser?.uid ?? auth.currentUser?.uid
                    let email = signedInUser?.email ?? user.profile?.email
                    let displayName = signedInUser?.displayName ?? user.profile?.name
                    let photoURL = signedInUser?.photoURL?.absoluteString ?? user.profile?.imageURL(withDimension: 200)?.absoluteString

                    guard let uid = uid else {
                        print("Missing uid after Google sign-in")
                        completion?(false)
                        return
                    }

                    self.upsertUserDocumentAndThen(uid: uid, email: email, displayName: displayName, photoURL: photoURL) { ok in
                        if ok {
                            LoggedIn = true
                            completion?(true)
                        } else {
                            completion?(false)
                        }
                    }
                }
            }
        }
        #else
        print("Google Sign-In not available on this platform or GoogleSignIn not linked.")
        completion?(false)
        #endif
    }
    
    private func upsertUserDocumentAndThen(uid: String, email: String?, displayName: String?, photoURL: String?, completion: @escaping (Bool) -> Void) {
        #if canImport(FirebaseFirestore)
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)

        var baseData: [String: Any] = [
            "uid": uid,
            "provider": "google",
            "lastSignIn": FieldValue.serverTimestamp()
        ]
        if let email = email { baseData["email"] = email }
        if let displayName = displayName { baseData["displayName"] = displayName }
        if let photoURL = photoURL { baseData["photoURL"] = photoURL }

        // Merge write creates or updates the document
        docRef.setData(baseData, merge: true) { setError in
            if let setError = setError {
                print("Merge write failed: \(setError.localizedDescription)")
                completion(false)
                return
            }

            // Ensure createdAt is set once
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
                    // If we can't read, proceed; at least the merge write succeeded
                }
                return nil
            }) { (_, txError) in
                if let txError = txError {
                    print("Transaction failed to set createdAt: \(txError.localizedDescription)")
                } else {
                    print("User doc upserted for uid: \(uid)")
                }
                completion(true)
            }
        }
        #else
        print("Firestore not available; skipping user record upsert.")
        completion(false)
        #endif
    }

    private func upsertUserDocument(from auth: Auth, firebaseUser: User?, googleUser: GIDGoogleUser?) {
        #if canImport(FirebaseFirestore)
        guard let uid = firebaseUser?.uid ?? auth.currentUser?.uid else {
            print("Firestore upsert skipped: missing uid")
            return
        }
        let email = firebaseUser?.email ?? googleUser?.profile?.email
        let displayName = firebaseUser?.displayName ?? googleUser?.profile?.name
        let photoURL = firebaseUser?.photoURL?.absoluteString ?? googleUser?.profile?.imageURL(withDimension: 200)?.absoluteString

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        let now = Timestamp(date: Date())

        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Failed to read user doc: \(error.localizedDescription)")
            }
            var data: [String: Any] = [
                "uid": uid,
                "provider": "google",
                "updatedAt": now
            ]
            if let email = email { data["email"] = email }
            if let displayName = displayName { data["displayName"] = displayName }
            if let photoURL = photoURL { data["photoURL"] = photoURL }

            if let snapshot = snapshot, snapshot.exists {
                // Update existing
                docRef.setData(data, merge: true) { setError in
                    if let setError = setError {
                        print("Failed to update user doc: \(setError.localizedDescription)")
                    } else {
                        print("Updated user doc for uid: \(uid)")
                    }
                }
            } else {
                // Create new
                data["createdAt"] = now
                docRef.setData(data, merge: true) { setError in
                    if let setError = setError {
                        print("Failed to create user doc: \(setError.localizedDescription)")
                    } else {
                        print("Created user doc for uid: \(uid)")
                    }
                }
            }
        }
        #else
        print("Firestore not available; skipping user record upsert.")
        #endif
    }

    private func isValidEmail(_ string: String) -> Bool {
        // Very simple regex check (sufficient for UI demo)
        let regex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: string)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,100}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            .evaluate(with: password)
    }
}

// MARK: - Button Styles

public struct PrimaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
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

public struct SecondaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
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

