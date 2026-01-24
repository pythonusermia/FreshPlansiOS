//
//  WeeklyPlanView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/16/26.
//
import SwiftUI
import SwiftData

struct WeeklyPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Recipe.dayNumber) var recipes: [Recipe]
    var viewModel: PlanViewModel
    
    // Grouping logic for the Day headers
    var days: [Int] {
        Array(Set(recipes.map { $0.dayNumber })).sorted()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with the "Coolors" style Regenerate button
                    HStack {
                        Text("Weekly Plan")
                            .font(.system(size: 34, weight: .bold))
                        Spacer()
                        Button(action: {
                            Task {
                                await viewModel.regenerateUnlocked()
                            }
                        }) {
                            Text("Regenerate")
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color(red: 185/255, green: 215/255, blue: 115/255))
                                .foregroundColor(.black)
                                .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal)

                    Divider().background(Color.black).padding(.horizontal)

                    ForEach(days, id: \.self) { day in
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Day \(day)")
                                .font(.title2.bold())
                                .padding(.horizontal)

                            // 2-Column Grid matching your screenshot
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(recipes.filter { $0.dayNumber == day }) { recipe in
                                    // NavigationLink enables clicking to see full details
                                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                        PlanRecipeCard(recipe: recipe, viewModel: viewModel)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            
                            Divider().padding(.vertical, 10)
                        }
                    }
                }
            }
        }
    }
}
