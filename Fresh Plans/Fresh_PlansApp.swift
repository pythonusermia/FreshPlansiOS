//
//  Fresh_PlansApp.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI
import SwiftData

@main
struct Fresh_PlansApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [UserPreferences.self, Recipe.self])
    }
}
