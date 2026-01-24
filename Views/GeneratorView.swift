//
//  GeneratorView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import SwiftUI
import SwiftData

struct GeneratorView: View {
    var viewModel: PlanViewModel
    @State private var isConfiguring = true
    @State private var days: Int = 7
    @State private var mealTypes: Set<String> = ["Dinner"]
    @State private var showSuccessAlert = false
    @Binding var selectedTab: Int
    
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isConfiguring {
                    configForm
                } else if viewModel.isLoading && viewModel.mealSlots.isEmpty {
                    VStack {
                        ProgressView()
                        Text("Building your plan...").padding()
                    }.frame(maxHeight: .infinity)
                } else {
                    // Use a ZStack so the Confirm button can float at the bottom
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                headerView
                                
                                // Grouping by Day
                                let dayGroups = Dictionary(grouping: viewModel.mealSlots, by: { $0.dayNumber })
                                    .sorted(by: { $0.key < $1.key })

                                ForEach(dayGroups, id: \.key) { day, recipes in
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Day \(day)").font(.title3.bold()).padding(.horizontal)
                                        
                                        LazyVGrid(columns: gridLayout, spacing: 15) {
                                            ForEach(recipes) { recipe in
                                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                                    PlanRecipeCard(recipe: recipe, viewModel: viewModel)
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                        .padding(.horizontal)
                                        Divider().padding(.top, 10)
                                    }
                                }
                                // Extra padding at bottom so the last recipe isn't hidden by the button
                                Spacer(minLength: 120)
                            }
                        }
                        
                        // THE CONFIRM BUTTON
                        confirmButtonOverlay
                    }
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            Text("Weekly Plan").font(.largeTitle.bold())
            Spacer()
            Button("Regenerate") { Task { await viewModel.regenerateUnlocked() } }
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Color.green.opacity(0.1)).foregroundColor(.green).cornerRadius(15).bold()
        }
        .padding()
    }

    // New UI Component for the Confirm Button
    private var confirmButtonOverlay: some View {
        VStack {
            Button(action: {
                viewModel.confirmMenu()
                showSuccessAlert = true // Trigger the feedback
            }) {
                Text("Confirm Menu & Get Groceries")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            .padding()
        }
        .alert("Plan Confirmed!", isPresented: $showSuccessAlert) {
            Button("Go to Grocery List") {
                // Switch to tag 2 (the Groceries tab)
                selectedTab = 2
            }
            Button("Stay Here", role: .cancel) { }
        } message: {
            Text("Your ingredients have been added to the Grocery List.")
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, Color(.systemBackground).opacity(0.8), Color(.systemBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var configForm: some View {
        Form {
            Stepper("\(days) Days", value: $days, in: 1...14)
            ForEach(["Breakfast", "Lunch", "Dinner"], id: \.self) { type in
                Toggle(type, isOn: Binding(
                    get: { mealTypes.contains(type) },
                    set: { isSelected in
                        if isSelected {
                            mealTypes.insert(type)
                        } else {
                            mealTypes.remove(type)
                        }
                    }
                ))
            }
            Button("Generate Plan") {
                isConfiguring = false
                Task { await viewModel.generateInitialPlan(days: days, types: Array(mealTypes), diet: "", exclusions: "") }
            }
            .frame(maxWidth: .infinity).buttonStyle(.borderedProminent)
        }
    }
}
