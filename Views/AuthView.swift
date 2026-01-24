//
//  AuthView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI

struct AuthView: View {
    var onAuthenticated: () -> Void // This is the 'link' back to OnboardingView
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account").font(.largeTitle.bold())
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            Button(action: {
                // This MUST be called to trigger completeOnboarding()
                onAuthenticated()
            }) {
                Text("Sign Up & Start Cooking")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
}
