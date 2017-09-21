//
//  RecipeTableViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/11/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit
import CoreData


class RecipeTableViewController: UITableViewController {
    
    let store = PersistanceService.store

    var selectedURL = ""
    var recipeArray = [RecipeFromURL]()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: reloadTableView)
//        let testRecipe = Recipe(url: "https://ketodietapp.com/Blog/post/2015/06/30/quick-frittata-with-tomatoes-and-cheese", meal: .dinner)
//        let testRecipeTwo = Recipe(url: "https://www.galonamission.com/easy-crockpot-chicken-stew-low-carb-keto/", meal: .dinner)
//        let testRecipeThree = Recipe(url: "https://yummyinspirations.net/2017/01/egg-roll-in-a-bowl-recipe/#sthash.2wHI8NcU.dpbs", meal: .dinner)
//        recipeArray.append(testRecipe)
//        recipeArray.append(testRecipeTwo)
//        recipeArray.append(testRecipeThree)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        store.fetchRecipes()
        recipeArray = store.fetchedRecipes
        self.tableView.reloadData()
    }
    
    func reloadTableView(notification:Notification) {
        self.store.fetchRecipes()
        self.recipeArray = self.store.fetchedRecipes
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipeArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        cell.cellLabel.text = recipeArray[indexPath.row].name
//        cell.cellRecipeImage.image = recipeArray[indexPath.row].image
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedURL = recipeArray[indexPath.row].url!
        performSegue(withIdentifier: "tablePressed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tablePressed" {
//            let destination = segue.destination as! WebViewController
//            destination.url = selectedURL
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! WebViewController
            target.url = selectedURL
        }
    }
    
    

}
