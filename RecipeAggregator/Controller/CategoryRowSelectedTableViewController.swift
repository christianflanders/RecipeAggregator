//
//  CategoryRowSelectedTableViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class CategoryRowSelectedTableViewController: UITableViewController, UIGestureRecognizerDelegate {
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
    private var categoryRowColors = recipeAppColors().detailViewColors.secondaryTableViewColors
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTableViewWithoutNotification()
        //we get this notification when the app is opened, allowing us to reload data for the tableview if a recipe has been added.
        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: reloadTableViewWithNotification)
        //Adding long press for tableViewOptions
        let longPressGesture = UILongPressGestureRecognizer(target: self, action:#selector(tableViewLongPressOnCell))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTableViewWithoutNotification()
        print("Hey I'm called now!!!!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: IBActions
    
    //MARK: Instance Methods
    func reloadTableViewWithNotification(notification:Notification) {
        store.fetchRecipes()
        masterRecipeArray = self.store.fetchedRecipes
        sortRecipes(categorySelected: categorySelected)
        self.downloadImagesFromUserDefaultsForRecipes(recipeArray: self.sortedRecipeArray)
        tableView.reloadData()
    }
    func reloadTableViewWithoutNotification() {
        store.fetchRecipes()
        masterRecipeArray = self.store.fetchedRecipes
        sortRecipes(categorySelected: categorySelected)
        self.downloadImagesFromUserDefaultsForRecipes(recipeArray: self.sortedRecipeArray)
        tableView.reloadData()
    }
    
    func sortRecipes(categorySelected: String) {
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
    
    func downloadImagesFromUserDefaultsForRecipes(recipeArray: [RecipeFromURL]){
        for i in recipeArray{
            if let image = storedImages.grabImageFromUserDefaults(location: i.url!) {
                storedImages.images[i.url!] = image
            } else {
                DispatchQueue.global(qos:.userInitiated).async {
                    if let previewImageURL = self.storedImages.getPreviewImageURLFromHTML(url: i.url!) {
                        let image = self.storedImages.downloadImageFromURL(previewImageURL)
                        self.storedImages.images[i.url!] = image
                        self.storedImages.storeImageInUserDefaults(image: image, location: i.url!)
                    }
                }
            }
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
        cell.selectionStyle = .none
        cell.backgroundColor = categoryRowColors[indexPath.row % 7]
        let selectedRecipe = sortedRecipeArray[indexPath.row]
        if let name = selectedRecipe.name {
            if name == "No name found" {
                cell.recipeNameLabel.text = "\(selectedRecipe.url!)"
            } else {
                cell.recipeNameLabel.text = name
            }
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let convertedDate = dateFormatter.string(from: selectedRecipe.dateAdded! as Date)
        cell.dateAddedLabel.text = convertedDate
        let recipeURL = selectedRecipe.url!
        cell.recipeRatingLabel.text = ratingToStarsForLabel(rating: selectedRecipe.rating)
        if let image = storedImages.images[recipeURL]{
            cell.recipeImageView?.image = image
        } else {
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let imageURL = self?.storedImages.getPreviewImageURLFromHTML(url: recipeURL) {
                    let image = self?.storedImages.downloadImageFromURL(imageURL)
                    self?.storedImages.images[recipeURL] = image
                    DispatchQueue.main.async { [weak self] in
                        if let cellToUpdate = self?.tableView?.cellForRow(at: indexPath) as? RecipeTableViewCell {
                            cellToUpdate.recipeImageView.image = self?.storedImages.images[recipeURL]
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
    
    @objc func tableViewLongPressOnCell(longPressGesture: UILongPressGestureRecognizer) {
        print("Long press detected")
        let press = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: press)
        if indexPath == nil {
            
        } else {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            performSegue(withIdentifier: "LongPressSegue", sender: self)
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
