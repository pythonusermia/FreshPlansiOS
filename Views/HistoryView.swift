//
//  HistoryView.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/15/26.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(filter: #Predicate<Recipe> { $0.isHearted == true }) var heartedRecipes: [Recipe]
    @State private var selectedFolder: String = "All"
    
    var folders: [String] {
        let uniqueFolders = Set(heartedRecipes.compactMap { $0.folderName })
        return ["All"] + Array(uniqueFolders).sorted()
    }
    
    var filteredRecipes: [Recipe] {
        if selectedFolder == "All" { return heartedRecipes }
        return heartedRecipes.filter { $0.folderName == selectedFolder }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Folder Picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(folders, id: \.self) { folder in
                            TagView(text: folder, isSelected: selectedFolder == folder) {
                                selectedFolder = folder
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                List(filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        VStack(alignment: .leading) {
                            Text(recipe.title).font(.headline)
                            if !recipe.userNotes.isEmpty {
                                Text(recipe.userNotes)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}
