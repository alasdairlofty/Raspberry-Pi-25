//
//  LoginOrNot.swift
//  Rasberry Pie 2025
//
//  Created by Oscar Mason on 28/10/2025.
//

import SwiftUI
import SwiftData
#if canImport(GoogleSignIn)
import GoogleSignIn
#endif
#if canImport(Firebase)
import Firebase
#endif

struct AccountOrNotView: View {
    @State private var showSignIn: Bool = false
    @State private var showCreateAccount: Bool = false
    @AppStorage("LoggedIn2") var LoggedIn2: Bool = false
    
    
    var body: some View {
        
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
                Text("Welcome to SenseCap")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                Text("Sign in or Create an account")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .padding(.top, 4)
            
            Spacer().frame(height: 20)
            
            
            
            VStack(spacing: 12) {
                Button(action: {
                    showSignIn = true
                }) {
                    HStack {
                        Image("sensecap_logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 10)
                        Spacer()
                        Text("Sign in to your account")
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                        Color.clear.frame(width: 20)
                       
                    }
                    .frame(height: 50)
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button(action: {
                    showCreateAccount = true
                }) {
                    HStack {
                        Image("sensecap_logo2")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 10)
                        Spacer()
                        Text("Create an account")
                            .font(.system(size: 15, weight: .medium))
                        Spacer()
                        Color.clear.frame(width: 20)
                    }
                    .frame(height: 50)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 24)
          
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .offset(y: -80)
        .ignoresSafeArea(edges: .bottom)
        .background(Color.white.ignoresSafeArea())
        
        
        .onOpenURL { url in
#if canImport(GoogleSignIn)
            _ = GIDSignIn.sharedInstance.handle(url)
#endif
        }
        .sheet(isPresented: $showSignIn) {
            SignIntoAccountView()
            
        }
        .sheet(isPresented: $showCreateAccount) {
            CreateAccountView()
            
        }
    }
}

