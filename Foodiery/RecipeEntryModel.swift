//
//  RecipeEntryModel.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/15.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import Foundation
import MapKit
import CoreImage

// MARK: - Recipes class ---> Holds multiple recipe entries.
class Recipes: NSObject, Codable{
    // Instance Variables
    var recipes: [RecipeEntry] = []
    var currentRecipeIndex: Int = 0
    
    convenience init(pRecipes: [RecipeEntry]){
        self.init()
        self.recipes = pRecipes
    }
    
    // Returns the current Recipe
    func getCurrentRecipe() -> RecipeEntry {
        
        return self.recipes[self.currentRecipeIndex]
    }
    
    func getPreviousRecipe(){
        if self.currentRecipeIndex == 0{
            self.currentRecipeIndex = (self.recipes.count - 1)
        }
        else{
            self.currentRecipeIndex -= 1
        }
    }
    
    // Increment the index of recipes by 1 and return the recipe
    func getNextRecipe() {
        if self.currentRecipeIndex + 1 == self.recipes.count{
            
            self.currentRecipeIndex = 0
        }
        else{
            self.currentRecipeIndex += 1
        }
    }
    
    // Delete the recipe. Only allows deleting the current viewing one by user. @TODO in ViewController
    func deleteRecipe() {
        self.recipes.remove(at: self.currentRecipeIndex)
    }
    
    // Returns the current index, to see which one is at which position. For debugging purposes.
    func checkIndex() -> Int{
        return self.currentRecipeIndex
    }
    
    // Function to return all Recipe Entries, whenever it contains the given food as parameter
    func getMatchingRecipes(pFood: String) -> [RecipeEntry] {
        var matchingEntries: [RecipeEntry] = []
        // Iterate over all recipe Entries, and get their foodused list
        for entry in self.recipes{
            for foodUsed in entry.foodUsedList{
                // If name matches.
                if foodUsed.name == pFood{
                    // Add the entry with matching food to matchingEntries. And break loop so if there are recurring matching stuff it does not appear twice.
                    matchingEntries.append(entry)
                    break
                }
            }
        }
        return matchingEntries
    }
    
    // MARK: Saving Method
    // To be called when user finishes editing an existing entry or creating a new one.
    func saveRecipes(){
           let fm = FileManager.default
           let docsURL = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           let recipesData = self
           let storedData = try! PropertyListEncoder().encode(recipesData)
           let moifile = docsURL.appendingPathComponent("Recipes_Data.plist")
           try! storedData.write(to: moifile, options: .atomic)
            print(docsURL)
    }
}


    // MARK: - RecipeEntry class
class RecipeEntry: NSObject, Codable {
    
    // MARK: Instance Variables
    
    // title: the title of one recipe entry
    var title: String = "Test Title"
    
    // time: time when this recipe is created
    var time: Date = Date()
    
    // recipeFormula: (Possibly)Paragraphs of words detailing how the dish is made, in recipe style.
    var recipeFormula: String = "Test Formula, test formula, test formula."
    
    // note: Extra complimentary notes, for user's convenience.
    var note: String = "Test Note"
    
    // The Food Tag functionality, where a list of all Food used in this recipe. The Food class is created below
    var foodUsedList: [Food] = [Food()]
    
    // photos: Photos uploaded by user, to this instance(possibly, and presumbly photos of food user cooked)
    lazy var photo: Data = Data() // Should be UIImage but UIImage does not conform to Codable.
    
    // location: stores the location where user posted this recipe.
//    var location: CLLocation
    
    convenience init(pTitle: String, pTime: Date, pRecipeFormula: String, pNote: String, pFoodUsedList: [Food], pPhotos: Data){
        self.init()
        self.title = pTitle
        self.time = pTime
        self.recipeFormula = pRecipeFormula
        self.note = pNote
        self.foodUsedList = pFoodUsedList
        self.photo = pPhotos
//        self.location = pLocation
    }
    
    // MARK: Public Methods
    
    // Returns the instances variables. Used in Browse Recipes View.
    func getTitle() -> String{
        return self.title
    }
    func getTime() -> Date{
        return self.time
    }
    func getRecipeFormula() -> String{
        return self.recipeFormula
    }
    func getNote() -> String{
        return self.note
    }
    func getFoodList() -> [Food]{
        return self.foodUsedList
    }
    func getPhotos() -> UIImage{
        // Check if the photo variable actually contains any objects.
        if let image = UIImage.init(data: self.photo){
            return image
        }
            // If not, return an empty UIImage so the View Controller does not break.
        else{
            return UIImage()
        }
        
    }
    // Saving Method: In its container class, see above, in Recipes{}
}

// MARK: - Food Class
class Food: NSObject, Codable {
    // MARK:  Instance Variables.
    var name: String = "Banana"
    
    var category: String = "Fruit"
    
    convenience init(pName: String, pCategory: String){
        self.init()
        self.name = pName
        self.category = pCategory
        }
    
}

class FoodList: NSObject, Codable{
    var foodList: [Food] = [Food()]
    
    convenience init(pFoodList: [Food]){
        self.init()
        self.foodList = pFoodList
    }
    
    // Function to get all the categories.
    func getAllCategory() -> [String]{
        var categoryList: [String] = []
        for food in self.foodList{
            if categoryList.contains(food.category){
                continue
            }
            else{
            categoryList.append(food.category)
            }
            
        }
        return categoryList
    }
    
    // This function iterates over food list and return a dictionary in the form of [Category: [food1, food2, food3]] for later use.
    func getFoodTagDict() -> [String: [String]]{
        let categoryKeysArray = self.getAllCategory()
        var foodTagDictionary: [String: [String]] = [:]
        
        for category in categoryKeysArray{
            var valueArray: [String] = []
            for food in self.foodList{
                if food.category == category{
                    valueArray.append(food.name)
                }
            }
            foodTagDictionary[category] = valueArray
        }
        return foodTagDictionary
    }
    
    // Save method to save model into persistent storage.
    func saveFoodList(){
           let fm = FileManager.default
           let docsURL = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           let foodListData = self
           let storedData = try! PropertyListEncoder().encode(foodListData)
           let moifile = docsURL.appendingPathComponent("FoodList_Data.plist")
           try! storedData.write(to: moifile, options: .atomic)
    }
    
    
}


