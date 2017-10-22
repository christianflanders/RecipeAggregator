//
//  CategoryRowSelectedTableViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class CategoryRowSelectedTableViewController: UITableViewController {
    //MARK: Enums
    
    //MARK: Constants
    private let store = PersistanceService.store
    
    
    //MARK: Variables
    var categorySelected = ""
    var selectedRecipe = RecipeFromURL()
    var storedImages = StoredImages()
    
    //MARK: Outlets
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    private var masterRecipeArray = [RecipeFromURL]()
    private var sortedRecipeArray = [RecipeFromURL]()
    
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Download recipes from CoreData
        store.fetchRecipes()
        masterRecipeArray = store.fetchedRecipes
        //Depending on the information we got from the mainselectionTableViewController, fiter our results to display the correct selection of recipes
        switch categorySelected {
        case "Breakfast":
            sortedRecipeArray = masterRecipeArray.filter {
                $0.meal == "Breakfast"
            }
        case "Lunch":
            sortedRecipeArray = masterRecipeArray.filter {
                $0.meal == "Lunch"
            }
        case "Dinner":
            sortedRecipeArray = masterRecipeArray.filter {
                $0.meal == "Dinner"
            }
        case "Snacks":
            sortedRecipeArray = masterRecipeArray.filter {
                $0.meal == "Snacks"
            }
        case "Favorites":
            sortedRecipeArray = masterRecipeArray.filter {
                $0.rating >= 4
            }
        case "Unsorted":
            sortedRecipeArray = masterRecipeArray.filter {
                $0.meal == "Unsorted"
            }
        case "All":
            sortedRecipeArray = masterRecipeArray
            
        default:
            fatalError("Fatal Error! Some unkown category was selected")
        }
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: IBActions
    
    //MARK: Instance Methods
        func ratingToStarsForLabel(rating: Int16) -> String {
    
            switch rating {
            case 0:
                return "No Rating!"
            case 1:
                return "⭐️"
            case 2:
                return "⭐️⭐️"
            case 3:
                return "⭐️⭐️⭐️"
            case 4:
                return "⭐️⭐️⭐️⭐️"
            case 5:
                return "⭐️⭐️⭐️⭐️⭐️"
            default:
                return "No Rating!"
            }
    
        }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sortedRecipeArray.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        let selectedRecipe = sortedRecipeArray[indexPath.row]
        if let name = selectedRecipe.name {
            cell.cellLabel.text = name

        }
        cell.dateAddedCell.text = String(describing: selectedRecipe.dateAdded)
        let recipeURL = selectedRecipe.url!
        cell.cellRatingLabel.text = ratingToStarsForLabel(rating: selectedRecipe.rating)
        if let image = storedImages.images[recipeURL]{
            cell.cellRecipeImage?.image = image
        } else {
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let imageURL = self?.storedImages.getPreviewImageURLFromHTML(url: recipeURL) {
                    let image = self?.storedImages.downloadImageFromURL(imageURL)
                    self?.storedImages.images[recipeURL] = image
                    DispatchQueue.main.async { [weak self] in
                        if let cellToUpdate = self?.tableView?.cellForRow(at: indexPath) as? RecipeTableViewCell {
                            cellToUpdate.cellRecipeImage.image = self?.storedImages.images[recipeURL]
                            tableView.rowHeight = 120
                            cellToUpdate.setNeedsLayout()
                        }
                    }
                }
            }
        }

        return cell
     }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = sortedRecipeArray[indexPath.row]
        performSegue(withIdentifier: "RecipeTablePressedSegue", sender: self)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeTablePressedSegue" {
            let destinationVC = segue.destination as! RecipeDetailViewController
            destinationVC.selectedRecipe = selectedRecipe
            if let imageToSend = storedImages.images[selectedRecipe.url!] {
                destinationVC.recipeImage = imageToSend
            }
        }
     }
 
}
