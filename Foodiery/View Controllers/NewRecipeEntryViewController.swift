//
//  NewRecipeEntryViewController.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/15.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import UIKit

import MapKit//Since the instance of new recipe needs CLocation, so.

// MARK: - NewRecipeEntryViewController
// Description - Is adopted by "New Recipe emoji" View. This View Controller should be responsible for collecting use's various inputs(title, data, photos, etc.). And once user clicks the "Done" button on upper-right corner, these entered information is passed to Recipes class, where the function that builds a Recipe Entry is called and the result is appended to the [RecipeEntry] array. Don't forget it saves the updated model as well.

class NewRecipeEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: TODO: The reference to AppDelegate's model:
    var appDelegate: AppDelegate?
    var lRecipesModel: Recipes?
    var lFoodListModel: FoodList?
    
    // A Variable called localAddedFoodList to temporarily hold added food, cleared in ViewDidLoad(), and passed to doneButton - constructor.
    private var localAddedFoodList: [Food] = []
    
    // Inititate a imagePicker
    let imagePicker = UIImagePickerController()
    
    // MARK: TODO: Link the @IBOutlet and @IBAction here.
    // MARK: Outlets and Actions
    @IBOutlet var recipeTitleTF: UITextField!
    @IBOutlet var recipeFormulaTF: UITextField!
    @IBOutlet var recipeNoteTF: UITextField!
    
    @IBOutlet var foodUsedListLabel: UILabel!
    
    
    @IBOutlet var foodCategoryTF: UITextField!
    @IBOutlet var foodNameTF: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var foodImageView: UIImageView!
    
    // MARK: Buttons' methods
    @IBAction func recipeDoneButton(_ sender: UIBarButtonItem) {
        // Get the title, recipe formula and note, all from textfields.
        let entryOfRecipeTitle = self.recipeTitleTF.text!
        let entryOfRecipeFormula = self.recipeFormulaTF.text!
        let entryOfNote = self.recipeNoteTF.text!
        
        // Access the local food list
        let foodUsedList = self.localAddedFoodList
        
        // Get the date.
        let entryOfDatePicker = datePicker.date
        
        // Convert photo to Data object, to be stored into RecipeEntry.
        let entryOfFoodImageView = foodImageView.image
        let imageData = entryOfFoodImageView!.pngData()
        
        // Create a new recipe entry into model.
        let newRecipe = RecipeEntry(pTitle: entryOfRecipeTitle, pTime: entryOfDatePicker, pRecipeFormula: entryOfRecipeFormula, pNote: entryOfNote, pFoodUsedList: foodUsedList, pPhotos: imageData!)
        self.lRecipesModel?.recipes.append(newRecipe)
        
        // Add the foods used to food list one by one.
        for food in foodUsedList {
            self.lFoodListModel?.foodList.append(food)
        }
        
        // Save the updated models.
        self.lRecipesModel?.saveRecipes()
        self.lFoodListModel?.saveFoodList()
        
        // Update the sibling VC.
        self.updateSiblingVC()
        self.updateVirtualFridgeVC()
        
        //Since the every label and text field are still user inputs, I add refresh actions here.
        //Yuanming Liu 6.19.2020  9:04am.
        self.recipeTitleTF.text = ""
        self.recipeFormulaTF.text = ""
        recipeNoteTF.text = ""
        self.foodCategoryTF.text = ""
        self.foodNameTF.text = ""
    }
    
    @IBAction func addFoodUsedButton(_ sender: Any) {
        let newCategory = self.foodCategoryTF.text!
        let newFoodName = self.foodNameTF.text!
        
        self.localAddedFoodList.append(Food(pName: newFoodName, pCategory: newCategory))
    }
    
    @IBAction func addPhotoButton(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: TODO: Methods and Protocols for UIImagePicker goes here.
    // MARK: Additional Protocols
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        // Get the user-picked image.
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.foodImageView.contentMode = .scaleAspectFit
            self.foodImageView.image = pickedImage // pass the picked image to imageView.
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Update Sibling View Controller Method *Could be reused by different VCs as well*
    func updateSiblingVC(){
        print("\(self.navigationItem)")
        print("\(String(describing: self.navigationController?.children[0]) )")
        (self.navigationController?.children[0] as! RecipesHomeViewController).recipeTableView.reloadData()
    }
    
    func updateVirtualFridgeVC(){
        if let containerVC = self.navigationController{
            print("\n \n \(containerVC)")
            if let rootVC = containerVC.tabBarController{
                print("\n \n \(rootVC)")
                
                if let siblingContainerVC = rootVC.viewControllers?[2]{
                    print("\n \n \(siblingContainerVC)")
                    
                    if let virtualFridgeVC = siblingContainerVC.children[0] as? VirtualFridgeViewController{
                        print("\n \n \(virtualFridgeVC) ")
                        
                        virtualFridgeVC.fillDataSource()
                        virtualFridgeVC.viewWillAppear(true)
                    }
                }
            }
        }
    }
        
        // MARK: View preparation method
        override func viewDidLoad() {
            super.viewDidLoad()
            imagePicker.delegate = self
            self.appDelegate = UIApplication.shared.delegate as? AppDelegate
            self.lRecipesModel = self.appDelegate?.recipeModel
            self.lFoodListModel = self.appDelegate?.foodListModel
            
            self.localAddedFoodList = []
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
