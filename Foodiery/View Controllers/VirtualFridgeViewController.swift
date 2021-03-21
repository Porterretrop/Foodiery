//
//  VirtualFridgeViewController.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/15.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import UIKit
//Comment 

class VirtualFridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource  {
    var appDelegate: AppDelegate?
    var lRecipesModel: Recipes?
    var lFoodListModel: FoodList?
    
    var allCategoryList: [String] = []// = ["SuanCaiYu","TianJi","SuanCaiHeiYu","TengJiaoHeiYu","PaoJiaoTianJi","GanGuoTianJi"]
    var foodTagDict: [String: [String]] = [:]
    var selectedFood: String = ""
    
    // Outlets
    @IBOutlet var foodPicker: UIPickerView!
    @IBOutlet var virtualFridgeTable: UITableView!
    
    // MARK: UIPickerView protocols
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    // Only two components, one for category, one for category's food, which is retrieved conditionally.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Return the number of rows dynamically.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // The first component, display count of category list
        if component == 0{
            return self.allCategoryList.count
        }
        else{
            // In the second component, the number of rows should be equal to however many food that belongs to the first category.
            // Need a function to dynamically return the number of elements in given category.
            // Using selectedRow. Need to make sure tho that the categoryList is in the same indexing as the component's row.
            
            let selectedCategoryNum = pickerView.selectedRow(inComponent: 0)
            let selectedCategory = self.allCategoryList[selectedCategoryNum]
            
            return self.foodTagDict[selectedCategory]!.count
        }
    }
    // Return the content in each row dynamically.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            return self.allCategoryList[row]
        }
        else{
            let selectedCategoryNum = pickerView.selectedRow(inComponent: 0)
            let selectedCategory = self.allCategoryList[selectedCategoryNum]
            
            return self.foodTagDict[selectedCategory]?[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            pickerView.reloadComponent(1)
        }
        else if component == 1{
            // If user has selected a food by stopping the scroll,
            // It should inform the table which recipe entries to present and refresh it.
            
            // Pass the informaiton to instance variable.
            let selectedCategoryNum = pickerView.selectedRow(inComponent: 0)
            let selectedCategory = self.allCategoryList[selectedCategoryNum]
            self.selectedFood = self.foodTagDict[selectedCategory]?[row] ?? "Water"
            print("\(self.selectedFood)")
            self.virtualFridgeTable.reloadData()
        }
    }
    
    // MARK: UITableView protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let matchingRecipeList = self.lRecipesModel?.getMatchingRecipes(pFood: self.selectedFood)
        
        return matchingRecipeList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchingRecipes", for: indexPath) as UITableViewCell
        
        let matchingRecipeList = self.lRecipesModel?.getMatchingRecipes(pFood: self.selectedFood)
        // Configure cell.
        print(matchingRecipeList?.count)
        cell.detailTextLabel?.text = matchingRecipeList?[indexPath.row].title
        cell.textLabel?.text = matchingRecipeList?[indexPath.row].time.description
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: View Preparation
    
    // Fill datasource from model
    func fillDataSource(){
        self.allCategoryList = lFoodListModel!.getAllCategory()
        self.foodTagDict = lFoodListModel!.getFoodTagDict()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.lRecipesModel = self.appDelegate?.recipeModel
        self.lFoodListModel = self.appDelegate?.foodListModel
        
        virtualFridgeTable.delegate = self
        virtualFridgeTable.dataSource = self
        foodPicker.delegate = self
        foodPicker.dataSource = self
        
        self.fillDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.foodPicker.reloadAllComponents()
        self.virtualFridgeTable.reloadData()
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
