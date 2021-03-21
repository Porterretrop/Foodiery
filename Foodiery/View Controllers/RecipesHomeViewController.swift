//
//  RecipesHomeViewController.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/15.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import UIKit

class RecipesHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Reference to AppDelegate and Model
    var appDelegate: AppDelegate?
    var lRecipesModel: Recipes?
    // No need to access FoodList Model here
    
    @IBOutlet weak var recipeTableView: UITableView!
    

    // Inititate TableViewDelegate
//    let lTableViewController = UITableViewController()
    // MARK: View Controller methods
    // Leave blank for now.
    
    // MARK: UITableViewDataSource Protocols
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recipes"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.lRecipesModel = self.appDelegate?.recipeModel
        
        let numberOfRows = self.lRecipesModel!.recipes.count
        return numberOfRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Return table cell, with its title being lRecipesModel.recipes[indexPath.row].title and its date being lRecipesModel.recipes[indexPath.row].time
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.lRecipesModel = self.appDelegate?.recipeModel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeEntries", for: indexPath) as! RecipeEntriesTableViewCellController
        
        let cellTitle = self.lRecipesModel!.recipes[indexPath.row].title
        let cellDate = self.lRecipesModel!.recipes[indexPath.row].time.description
        
        cell.recipeTitleLabel.text = cellTitle
        cell.recipeDateLabel.text = cellDate
        print("Cell generated")
        return cell
    }
    
    // Never, ever forget this
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }

    // MARK: View preparation
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.lRecipesModel = self.appDelegate?.recipeModel
        // set delegate and datasource
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        

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
