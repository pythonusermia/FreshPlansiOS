//
//  ContentView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var preferences: [UserPreferences]
    
    var body: some View {
        // Log to the console so we can debug
        let _ = print("🔍 Preference count: \(preferences.count)")
        let _ = print("✅ Is first one complete?: \(preferences.first?.isOnboardingComplete ?? false)")

        if let user = preferences.first, user.isOnboardingComplete {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
