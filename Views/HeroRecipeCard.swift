//
//  HeroRecipeCard.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/19/26.
//
import SwiftUI

struct HeroRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: recipe.image)) { img in
                img.resizable().aspectRatio(contentMode: .fill)
            } placeholder: { Color.gray.opacity(0.2) }
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            // Gradient Overlay for readability
            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.mealType.uppercased())
                    .font(.caption.bold())
                    .foregroundColor(.green)
                
                Text(recipe.title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                
                Label("\(recipe.readyInMinutes) minutes", systemImage: "timer")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(20)
        }
        .shadow(radius: 10)
    }
}
