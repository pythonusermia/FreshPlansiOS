//
//  DashboardView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Recipe> { $0.isSavedToPlan == true }) var plannedRecipes: [Recipe]

    var recipeOfTheDay: Recipe? {
        plannedRecipes.first(where: { $0.dayNumber == 1 && $0.mealType == "Dinner" })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // FEATURE 1: Recipe of the Day Hero Card
                    if let recipe = recipeOfTheDay {
                        VStack(alignment: .leading) {
                            Text("Recipe of the Day")
                                .font(.title2.bold())
                            
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                HeroRecipeCard(recipe: recipe)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)
                    } else {
                        ContentUnavailableView("No Meal Planned", systemImage: "calendar.badge.plus", description: Text("Go to the Plan tab to generate today's meals."))
                    }

                    // FEATURE 2: Quick Stats Row
                    HStack(spacing: 15) {
                        StatCard(title: "Total Time", value: "\(recipeOfTheDay?.readyInMinutes ?? 0)m", icon: "clock", color: .blue)
                        StatCard(title: "Servings", value: "\(recipeOfTheDay?.servings ?? 0)", icon: "person.2", color: .orange)
                    }
                    .padding(.horizontal)
                    
                    // FEATURE 3: Upcoming Meals Mini-List
                    VStack(alignment: .leading) {
                        Text("Coming Up Next")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Show tomorrow's breakfast/lunch
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(plannedRecipes.filter { $0.dayNumber == 2 }) { nextMeal in
                                    MiniRecipeCard(recipe: nextMeal)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Fresh Plans")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(value)
                    .font(.headline)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(15)
    }
}

struct MiniRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: recipe.image)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: { Color.gray.opacity(0.1) }
            .frame(width: 140, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(recipe.mealType)
                .font(.caption2.bold())
                .foregroundColor(.green)
            
            Text(recipe.title)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)
                .frame(width: 130, alignment: .leading)
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}
