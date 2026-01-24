//
//  UserPreferences.swift
//  Fresh Plans
//
//  Created by Mia Yonker on 1/14/26.
//
import Foundation
import SwiftData

@Model
class UserPreferences {
    var diet: String = "None"
    var excludedIngredients: String = ""
    var isOnboardingComplete: Bool = false
    
    var cookingTimeLimit: Int = 30
    var preferredCuisines: [String] = []
    var favoriteWebsites: [String] = []
    
    var customFolders: [String] = ["Favorites", "To Try"]
    
    init(diet: String = "None",
         excludedIngredients: String = "",
         cookingTimeLimit: Int = 30,
         preferredCuisines: [String] = [],
         favoriteWebsites: [String] = []) {
        self.diet = diet
        self.excludedIngredients = excludedIngredients
        self.cookingTimeLimit = cookingTimeLimit
        self.preferredCuisines = preferredCuisines
        self.favoriteWebsites = favoriteWebsites
    }
}
