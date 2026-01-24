//
//  RecipeDetailView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/15/26.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var details: RecipeDetailResponse?
    @State private var isLoading = true
    private let service = SpoonacularService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Large Hero Image
                AsyncImage(url: URL(string: recipe.image)) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.1))
                }
                .frame(height: 300)
                .clipped()

                VStack(alignment: .leading, spacing: 15) {
                    Text(recipe.title)
                        .font(.largeTitle.bold())

                    HStack(spacing: 20) {
                        Label("\(recipe.readyInMinutes) min", systemImage: "clock")
                        Label("\(recipe.servings) servings", systemImage: "person.2")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Divider()

                    if isLoading {
                        ProgressView("Fetching details...")
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else if let details = details {
                        // Ingredients Section
                        Text("Ingredients")
                            .font(.title2.bold())
                        
                        ForEach(details.extendedIngredients) { ingredient in
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.green)
                                Text(ingredient.displayLabel)
                            }
                            .padding(.vertical, 2)
                        }

                        Divider()

                        // Instructions Section
                        Text("Instructions")
                            .font(.title2.bold())
                        
                        Text(recipe.instructions ?? "No instructions provided. Tap below to visit the original website.")
                            .lineSpacing(6)
                    }

                    // Link to Website
                    if !recipe.sourceUrl.isEmpty {
                        Link(destination: URL(string: recipe.sourceUrl)!) {
                            HStack {
                                Text("View Full Recipe on Website")
                                Image(systemName: "arrow.up.right.square")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                        }
                        .padding(.top, 20)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchDetails()
        }
    }

    private func fetchDetails() {
        Task {
            do {
                let responses = try await service.fetchRecipeDetails(ids: [recipe.id])
                await MainActor.run {
                    self.details = responses.first
                    self.isLoading = false
                }
            } catch {
                await MainActor.run { self.isLoading = false }
            }
        }
    }
}
