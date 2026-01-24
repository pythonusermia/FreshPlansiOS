//
//  PlanRecipeCard.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/16/26.
//

import SwiftUI
import SwiftData

struct PlanRecipeCard: View {
    let recipe: Recipe
    var viewModel: PlanViewModel

    // Time Formatting Logic
    var timeLabel: String {
        if recipe.readyInMinutes >= 60 {
            let h = recipe.readyInMinutes / 60
            let m = recipe.readyInMinutes % 60
            return m > 0 ? "\(h)h \(m)m" : "\(h)h"
        }
        return "\(recipe.readyInMinutes)m"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: recipe.image)) { img in
                    img.resizable().aspectRatio(contentMode: .fill)
                } placeholder: { Color.gray.opacity(0.1) }
                .frame(width: 165, height: 140)
                .clipped()
                .cornerRadius(12)

                // Lock Button
                Button { viewModel.toggleLock(recipe: recipe) } label: {
                    Image(systemName: recipe.isLocked ? "lock.fill" : "lock.open.fill")
                        .padding(8)
                        .background(recipe.isLocked ? Color.green : Color.white.opacity(0.8))
                        .foregroundColor(recipe.isLocked ? .white : .black)
                        .clipShape(Circle())
                }
                .padding(6)
            }

            VStack(alignment: .leading, spacing: 2) {
                // Label 1: Meal Type
                Text(recipe.mealType.uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                
                // Label 2: Recipe Name
                Text(recipe.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(height: 38, alignment: .top)

                // Time/Servings
                HStack {
                    Text(timeLabel)
                    Spacer()
                    Text("\(recipe.servings) servings")
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
