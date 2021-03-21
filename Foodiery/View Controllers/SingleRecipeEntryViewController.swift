//
//  NewRecipeEntryViewController.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/15.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import UIKit

class SingleRecipeEntryViewController: UIViewController {
    
    // MARK: The reference to AppDelegate's Model object:
    var appDelegate: AppDelegate?
    var lRecipesModel: Recipes?
    var lFoodListModel: FoodList?
    
    
    // MARK: @IBOutlets and @IBActions
    // link to views object here

    // Below are the respective fields.
    @IBOutlet var recipePhotoView: UIImageView!
    
    @IBOutlet var recipeFormulaLabel: UILabel!
    
    @IBOutlet var recipeNoteLabel: UILabel!
    
    @IBOutlet var recipeFoodListLabel: UILabel!
    
    @IBOutlet var recipeTimeLabel: UILabel!
    
    
    // MARK: Methods
    
    // Function to check if the initiated model Recipes's recipes array is empty.
    func checkRecipesIfEmpty() -> Bool{
        if self.lRecipesModel?.recipes.count == 0{
            // If recipes is empty
            return false // Return negative
        }
        else{
            return true
        }
    }
    
    // Call the checkRecipesIfEmpty() function to determine whether to present the recipe. If Recipes array is indeed empty, let view controller display nothing, so it does not break.
    func conditionalPresentRecipe() {
        if self.checkRecipesIfEmpty() == true {
            self.presentRecipe()
        }
}

    // Function to load all respective fields' data
    func presentRecipe(){
        // Retrieve model again so it can enable updating.
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.lRecipesModel = self.appDelegate?.recipeModel
        
        // model is of Recipes type.
        let model = self.lRecipesModel
        
        // currentRecipe is of RecipeEntry type. Default to be the first one(index of 0)
        let currentRecipe = model?.getCurrentRecipe()
        
        // Get photo
        self.recipePhotoView.image = currentRecipe!.getPhotos()
        // Get recipe formula
        self.recipeFormulaLabel.text = "Formula: \(currentRecipe!.getRecipeFormula())"
        // Get recipe note
        self.recipeNoteLabel.text = "Note: \( currentRecipe!.getNote())"
        // Get food used list
        self.recipeFoodListLabel.text = "Food Used: \(currentRecipe!.getFoodList().description)"
        // Get time
        self.recipeTimeLabel.text = "Created at: \(currentRecipe!.getTime().description)"

    }
    
    // Two bar button for navigating through recipes. Not using pages here, but rather just update respective fields with respective entries. Track using index.
    
    @IBAction func previousEntryButton(_ sender: Any) {
        // Navigate back by 1 index
        self.lRecipesModel?.getPreviousRecipe()
        self.conditionalPresentRecipe()
        
    }
    @IBAction func nextEntryButton(_ sender: Any) {
        //Navigate forth by 1 index
        self.lRecipesModel?.getNextRecipe()
        self.conditionalPresentRecipe()
        
    }
    
    // MARK: View Loading Preparation
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get reference to all required models.
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.lRecipesModel = self.appDelegate?.recipeModel
        self.lFoodListModel = self.appDelegate?.foodListModel
        
        self.conditionalPresentRecipe()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
