//
//  AppDelegate.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/14.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // PlaceHolder for Recipes, be assigned later when AppDelegate runs. If none of the model exists, return a default one.
    var recipeModel: Recipes?
    var foodListModel: FoodList?
    
    // Function to load existing model, if there is one.
    func loadRecipesModel(){
        do{
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory,
                                     in: .userDomainMask, appropriateFor: nil, create: false)
            let dataFile = docsurl.appendingPathComponent("Recipes_Data.plist")
            let recipesData = try Data(contentsOf: dataFile)
            self.recipeModel = try PropertyListDecoder().decode(Recipes.self, from: recipesData)
            print("\(docsurl)")
        }
        catch {
            print("\n The Recipes model failed to load bruh")
            let fm = FileManager.default
            let docsurl = try! fm.url(for:.documentDirectory,
                                     in: .userDomainMask, appropriateFor: nil, create: false)
            print("\n \n The sandbox is at \(docsurl)")
            self.recipeModel = Recipes()
        }
        
    }
    
    func loadFoodListData(){
        do{
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory,
                                     in: .userDomainMask, appropriateFor: nil, create: false)
            let dataFile = docsurl.appendingPathComponent("FoodList_Data.plist")
            let foodListData = try Data(contentsOf: dataFile)
            self.foodListModel = try PropertyListDecoder().decode(FoodList.self, from: foodListData)
            print("\(docsurl)")
        }
        catch {
            print("\n the FoodList model failed to load bruh")
            let fm = FileManager.default
            let docsurl = try! fm.url(for:.documentDirectory,
                                     in: .userDomainMask, appropriateFor: nil, create: false)
            print("\n \n The sandbox is at \(docsurl)")
            self.foodListModel = FoodList()
        }
        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.loadRecipesModel()
        self.loadFoodListData()
       
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

