//
//  PlanViewModel.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import Foundation
import SwiftData
import Observation

@Observable
class PlanViewModel {
    var modelContext: ModelContext?
    var mealSlots: [Recipe] = []
    var isLoading = false
    private let service = SpoonacularService()

    func fetchSavedPlan() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.dayNumber), SortDescriptor(\.mealType)])
        do {
            self.mealSlots = try context.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    // HELPER: Caching Logic - Checks database before API
    private func getOrFetchRecipe(type: String, diet: String, exclusions: String, usedIds: Set<Int>) async -> Recipe? {
        let apiType = type.lowercased() == "breakfast" ? "breakfast" : "main course"
        
        // 1. Check Cache: Look for a recipe we already have in SwiftData that matches the type
        // and isn't currently displayed or part of a saved plan.
        let descriptor = FetchDescriptor<Recipe>(
            predicate: #Predicate<Recipe> { recipe in
                recipe.mealType == type && !recipe.isSavedToPlan
            }
        )
        
        if let cachedRecipes = try? modelContext?.fetch(descriptor) {
            // Find a cached one we haven't already used in this specific session
            if let cached = cachedRecipes.first(where: { !usedIds.contains($0.id) }) {
                return cached
            }
        }
        
        // 2. Fetch from API: Only if no valid cached recipes are found
        do {
            let results = try await service.fetchFilteredRecipes(type: apiType, diet: diet, exclusions: exclusions)
            if let newRecipe = results.first(where: { !usedIds.contains($0.id) }) {
                return newRecipe
            }
        } catch {
            print("Network error: \(error)")
        }
        
        return nil
    }

    func generateInitialPlan(days: Int, types: [String], diet: String, exclusions: String) async {
        await MainActor.run {
            self.isLoading = true
            // We clear mealSlots, but we DON'T necessarily delete all Recipes from the DB anymore
            // because we want to keep them as cache. We only delete recipes that were "Saved to Plan"
            // if we are starting a brand new week.
            if let context = modelContext {
                try? context.delete(model: Recipe.self, where: #Predicate<Recipe> { $0.isSavedToPlan })
            }
            self.mealSlots = []
        }
        
        var usedIds = Set<Int>()

        for day in 1...days {
            for type in types {
                // Use the caching helper
                if let recipe = await getOrFetchRecipe(type: type, diet: diet, exclusions: exclusions, usedIds: usedIds) {
                    usedIds.insert(recipe.id)
                    recipe.dayNumber = day
                    recipe.mealType = type
                    
                    await MainActor.run {
                        self.modelContext?.insert(recipe)
                        self.mealSlots.append(recipe)
                    }
                }
            }
        }
        await MainActor.run { self.isLoading = false }
    }

    func toggleLock(recipe: Recipe) {
        recipe.isLocked.toggle()
        try? modelContext?.save()
    }

    func regenerateUnlocked() async {
        await MainActor.run { self.isLoading = true }
        var usedIds = Set(mealSlots.map { $0.id })
        
        for recipe in mealSlots where !recipe.isLocked {
            // Use the caching helper for regeneration too
            if let match = await getOrFetchRecipe(type: recipe.mealType, diet: "", exclusions: "", usedIds: usedIds) {
                usedIds.insert(match.id)
                await MainActor.run {
                    recipe.id = match.id
                    recipe.title = match.title
                    recipe.image = match.image
                    recipe.readyInMinutes = match.readyInMinutes
                    recipe.servings = match.servings
                    recipe.ingredients = match.ingredients 
                }
            }
        }
        await MainActor.run { self.isLoading = false }
    }
    
    func confirmMenu() {
        for recipe in mealSlots {
            recipe.isSavedToPlan = true
        }
        
        do {
            try modelContext?.save()
            print("Menu confirmed and saved!")
        } catch {
            print("Failed to save menu: \(error)")
        }
    }
}
