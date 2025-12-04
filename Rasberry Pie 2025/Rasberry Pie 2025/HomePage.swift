//
//  HomePage.swift
//  Rasberry Pie 2025
//
//  Created by Oscar Mason on 28/10/2025.
//

import SwiftUI
import UIKit
import SwiftData

struct HomePage: View {
    @AppStorage("LoggedIn2") private var loggedIn2: Bool = false

    var body: some View {
        Group {
            if loggedIn2 {
                HomeView()
            } else {
                AccountOrNotView()
            }
        }
    }
}

struct HomeView: View {
    @AppStorage("LoggedIn2") private var LoggedIn2: Bool = false
    var body: some View {
        
        VStack(spacing: 12) {
            Button(action: {
                LoggedIn2 = false
            }) {
                HStack {
                    Image("sensecap_logo2")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 10)
                    Spacer()
                    Text("Logout")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .frame(height: 50)
            }
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
        }
    }
}
