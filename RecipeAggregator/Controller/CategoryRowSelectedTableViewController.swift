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
    private var categoryRowColors = [UIColor.init(red: 218/255, green: 69/255, blue: 83/255, alpha: 1), UIColor.init(red: 233/255, green: 87/255, blue: 62/255, alpha: 1),UIColor.init(red: 246/255, green: 187/255, blue: 67/255, alpha: 1), UIColor.init(red: 140/255, green: 192/255, blue: 81/255, alpha: 1), UIColor.init(red: 55/255, green: 187/255, blue: 155/255, alpha: 1), UIColor.init(red: 60/255, green: 174/255, blue: 218/255, alpha: 1),UIColor.init(red: 150/255, green: 123/255, blue: 220/255, alpha: 1),]
    
    
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
        //        //we get this notification when the app is opened, allowing us to reload data for the tableview if a recipe has been added.
    NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: reloadTableView)
}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
//MARK: IBActions

//MARK: Instance Methods
func reloadTableView(notification:Notification) {
    self.store.fetchRecipes()
    self.masterRecipeArray = self.store.fetchedRecipes
    //        imageArray.removeAll()
    //        for _ in 0..<recipeArray.count {
    //            print("Doing shit!")
    //            imageArray.append(#imageLiteral(resourceName: "errorstop"))
    //        }
    self.tableView.reloadData()
}

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
    cell.backgroundColor = categoryRowColors[indexPath.row % 7]
    let selectedRecipe = sortedRecipeArray[indexPath.row]
    if let name = selectedRecipe.name {
        if name == "No name found" {
            cell.cellLabel.text = "\(selectedRecipe.url!)"
        } else {
            cell.cellLabel.text = name
        }
        
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    let convertedDate = dateFormatter.string(from: selectedRecipe.dateAdded! as Date)
    cell.dateAddedCell.text = convertedDate
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            store.delete(recipe: sortedRecipeArray[indexPath.row])
            sortedRecipeArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
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
