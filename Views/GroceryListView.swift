//
//  GroceryListView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI
import SwiftData

struct GroceryListView: View {
    // This Query automatically updates whenever a recipe's 'isSavedToPlan' changes
    @Query(filter: #Predicate<Recipe> { $0.isSavedToPlan == true })
    private var plannedRecipes: [Recipe]
    
    // We'll keep a simple local state for checking off items during a shopping trip
    @State private var checkedItems: Set<String> = []
    
    // Flattens all ingredients from all planned recipes into one list
    var allIngredients: [String] {
        Array(Set(plannedRecipes.flatMap { $0.ingredients })).sorted()
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if plannedRecipes.isEmpty {
                    ContentUnavailableView(
                        "No Groceries",
                        systemImage: "cart",
                        description: Text("Confirm a meal plan in the Generator to see your ingredients.")
                    )
                } else {
                    List {
                        Section("To Buy") {
                            ForEach(allIngredients.filter { !checkedItems.contains($0) }, id: \.self) { item in
                                GroceryRowView(item: item, isChecked: false) {
                                    checkedItems.insert(item)
                                }
                            }
                        }
                        
                        if !checkedItems.isEmpty {
                            Section("In Cart") {
                                ForEach(allIngredients.filter { checkedItems.contains($0) }, id: \.self) { item in
                                    GroceryRowView(item: item, isChecked: true) {
                                        checkedItems.remove(item)
                                    }
                                    .opacity(0.5)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Grocery List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset Plan", role: .destructive) {
                        // This clears the 'isSavedToPlan' flag so you can start a new week
                        for recipe in plannedRecipes {
                            recipe.isSavedToPlan = false
                        }
                    }
                }
                if !allIngredients.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        ShareLink(item: generateShareText()) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear All") {
                            checkedItems.removeAll()
                        }
                    }
                }
            }
        }
    }
    
    private func generateShareText() -> String {
        "My Grocery List:\n" + allIngredients.map { "- \($0)" }.joined(separator: "\n")
    }
}

// MARK: - Subview
struct GroceryRowView: View {
    let item: String
    let isChecked: Bool
    var onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .green : .gray)
                
                Text(item)
                    .strikethrough(isChecked)
                    .foregroundColor(isChecked ? .secondary : .primary)
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
