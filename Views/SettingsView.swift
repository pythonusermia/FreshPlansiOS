//
//  SettingsView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/15/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var prefs: [UserPreferences]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Dietary Profile") {
                    Text("Current Diet: \(prefs.first?.diet ?? "None")")
                    Text("Exclusions: \(prefs.first?.excludedIngredients ?? "None")")
                }
                
                Section("App Data") {
                    Button("Reset Onboarding", role: .destructive) {
                        resetApp()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func resetApp() {
        // Delete preferences to trigger OnboardingView in ContentView
        if let existing = prefs.first {
            modelContext.delete(existing)
            try? modelContext.save()
        }
    }
}
