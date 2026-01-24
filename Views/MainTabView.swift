//
//  MainTabView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var planViewModel = PlanViewModel()
    
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Today", systemImage: "house.fill") }
                .tag(0)
            
            GeneratorView(viewModel: planViewModel, selectedTab: $selectedTab)
                .tabItem { Label("Plan", systemImage: "sparkles") }
                .tag(1)
            
            GroceryListView()
                .tabItem { Label("Groceries", systemImage: "cart.fill") }
                .tag(2)
                
            HistoryView()
                .tabItem { Label("History", systemImage: "clock.fill") }
                .tag(3)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .onAppear {
            planViewModel.modelContext = modelContext
            planViewModel.fetchSavedPlan()
        }
        .tint(.green)
    }
}
