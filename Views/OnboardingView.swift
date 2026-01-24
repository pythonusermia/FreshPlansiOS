//
//  OnboardingView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var prefs: [UserPreferences]
    
    // Input States
    @State private var timeLimit = 30.0
    @State private var selectedDiet = "None"
    @State private var allergySearch = ""
    @State private var selectedAllergies: Set<String> = []
    @State private var selectedCuisines: Set<String> = []
    @State private var selectedWebsites: [String] = []
    
    // Navigation State
    @State private var stepStack: [OnboardingStep] = [.time]
    
    let allCuisines = ["Italian", "Mexican", "Asian", "American", "Mediterranean", "French", "Indian", "Thai"]
    let commonAllergens = ["Peanuts", "Dairy", "Gluten", "Shellfish", "Soy", "Eggs", "Cilantro", "Mushrooms", "Onions", "Garlic"]

    enum OnboardingStep: Hashable {
        case time, diet, allergies, cuisine, websites, auth
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Progress bar updated to 6 steps now
                ProgressBar(currentStep: stepStack.count, totalSteps: 6)
                    .padding(.top)
                
                switch stepStack.last! {
                case .time:
                    OnboardingStepView(title: "Time Limit", subtitle: "What is your max cooking time?") {
                        VStack {
                            Text("\(Int(timeLimit)) min").font(.largeTitle).bold().foregroundStyle(.green)
                            Slider(value: $timeLimit, in: 15...90, step: 5)
                        }
                    }
                    
                case .diet:
                    OnboardingStepView(title: "Dietary Preference", subtitle: "Choose your primary style") {
                        Picker("Diet", selection: $selectedDiet) {
                            ForEach(["None", "Vegetarian", "Vegan", "Keto", "Paleo"], id: \.self) { Text($0) }
                        }.pickerStyle(.wheel)
                    }
                    
                case .allergies:
                    OnboardingStepView(title: "Dislikes & Allergies", subtitle: "Search items to exclude") {
                        VStack(spacing: 15) {
                            TextField("Search foods...", text: $allergySearch)
                                .textFieldStyle(.roundedBorder)
                            
                            if !selectedAllergies.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(Array(selectedAllergies).sorted(), id: \.self) { item in
                                            TagView(text: item, isSelected: true) { selectedAllergies.remove(item) }
                                        }
                                    }
                                }.frame(height: 40)
                            }
                            
                            List {
                                let filtered = commonAllergens.filter {
                                    allergySearch.isEmpty ? true : $0.localizedCaseInsensitiveContains(allergySearch)
                                }
                                ForEach(filtered, id: \.self) { item in
                                    Button(action: {
                                        if selectedAllergies.contains(item) { selectedAllergies.remove(item) }
                                        else { selectedAllergies.insert(item) }
                                    }) {
                                        HStack {
                                            Text(item)
                                            Spacer()
                                            if selectedAllergies.contains(item) { Image(systemName: "checkmark").foregroundColor(.green) }
                                        }
                                    }.foregroundStyle(selectedAllergies.contains(item) ? .green : .primary)
                                }
                            }
                            .listStyle(.plain).frame(height: 200).cornerRadius(12)
                        }
                    }
                    
                case .cuisine:
                    OnboardingStepView(title: "Favorite Cuisines", subtitle: "Select all that you love") {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                                ForEach(allCuisines, id: \.self) { item in
                                    TagView(text: item, isSelected: selectedCuisines.contains(item)) {
                                        if selectedCuisines.contains(item) { selectedCuisines.remove(item) }
                                        else { selectedCuisines.insert(item) }
                                    }
                                }
                            }
                        }
                    }
                    
                case .websites:
                    WebsiteSelectionView(selectedSites: $selectedWebsites)
                    
                case .auth:
                    AuthView { completeOnboarding() }
                }

                Spacer()
                
                // Bottom Navigation
                HStack(spacing: 20) {
                    if stepStack.count > 1 {
                        Button("Back") {
                            withAnimation { let _ = stepStack.removeLast() }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if stepStack.last! != .auth {
                        Button("Next") {
                            withAnimation { advance() }
                        }
                        .buttonStyle(.borderedProminent).tint(.green).frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
    }

    private func advance() {
        switch stepStack.last! {
        case .time: stepStack.append(.diet)
        case .diet: stepStack.append(.allergies)
        case .allergies: stepStack.append(.cuisine)
        case .cuisine: stepStack.append(.websites)
        case .websites: stepStack.append(.auth)
        default: break
        }
    }

    private func completeOnboarding() {
        // Create new preferences and populate ALL fields
        let newPrefs = UserPreferences()
        newPrefs.cookingTimeLimit = Int(timeLimit)
        newPrefs.diet = selectedDiet
        newPrefs.excludedIngredients = Array(selectedAllergies).joined(separator: ",")
        newPrefs.preferredCuisines = Array(selectedCuisines)
        newPrefs.favoriteWebsites = selectedWebsites
        newPrefs.isOnboardingComplete = true
        
        modelContext.insert(newPrefs)
        
        do {
            try modelContext.save()
            print("Successfully saved and completed onboarding.")
        } catch {
            print("Failed to save preferences: \(error)")
        }
    }
}

struct WebsiteSelectionView: View {
    @Binding var selectedSites: [String]
    @State private var searchText = ""
    
    let popularSites = [
        "AllRecipes", "Food Network", "Epicurious",
        "Serious Eats", "Bon Appétit", "NYT Cooking",
        "Pinch of Yum", "Sally's Baking Addiction", "Delish"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Favorite Sources")
                    .font(.title.bold())
                Text("Pick sites you love to see them more often.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Search & Add Bar
            HStack {
                TextField("Search or add a website...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                
                if !searchText.isEmpty {
                    Button {
                        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !selectedSites.contains(trimmed) {
                            selectedSites.append(trimmed)
                        }
                        searchText = ""
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Selected Items Section
                    if !selectedSites.isEmpty {
                        Text("Selected")
                            .font(.caption).bold().foregroundStyle(.secondary)
                        
                        // Using a simple wrapped grid for selection
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(selectedSites, id: \.self) { site in
                                TagView(text: site, isSelected: true) {
                                    selectedSites.removeAll { $0 == site }
                                }
                            }
                        }
                    }
                    
                    Divider().padding(.vertical, 5)
                    
                    Text("Suggestions")
                        .font(.caption).bold().foregroundStyle(.secondary)
                    
                    // Suggestions Grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))], spacing: 12) {
                        ForEach(popularSites, id: \.self) { site in
                            let isSelected = selectedSites.contains(site)
                            
                            Button {
                                if isSelected {
                                    selectedSites.removeAll { $0 == site }
                                } else {
                                    selectedSites.append(site)
                                }
                            } label: {
                                Text(site)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(isSelected ? Color.green.opacity(0.15) : Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                                    )
                                    .foregroundColor(isSelected ? .green : .primary)
                                    .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
