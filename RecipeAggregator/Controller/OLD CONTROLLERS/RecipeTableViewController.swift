////
////  RecipeTableViewController.swift
////  RecipeAggregator
////
////  Created by Christian Flanders on 9/11/17.
////  Copyright © 2017 Christian Flanders. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//
//class RecipeTableViewController: UITableViewController {
//
//    let store = PersistanceService.store
//
//    var selectedURL = ""
//    var recipeArray = [RecipeFromURL]()
//    var storedImages = [String:UIImage]()
//    var selectedRecipe = RecipeFromURL()
//    var whatToSortBy: SortBy = .date
//
//
//
//
//
//    @IBOutlet weak var addButton: UIBarButtonItem!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //we get this notification when the app is opened, allowing us to reload data for the tableview if a recipe has been added.
//        NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil, using: reloadTableView)
//
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        store.fetchRecipes()
//        recipeArray = store.fetchedRecipes
//        recipeArray.sort {
//            switch whatToSortBy {
//            case .date:
//                return $0.dateAdded! > $1.dateAdded!
//            case .rating:
//                return $0.rating > $1.rating
//            default:
//                return $0.name! < $1.name!
//            }
//
//        }
//        print("stored images count is \(storedImages.count)")
//        self.tableView.reloadData()
//
//    }
//
//    func reloadTableView(notification:Notification) {
//        self.store.fetchRecipes()
//        self.recipeArray = self.store.fetchedRecipes
//        //        imageArray.removeAll()
//        //        for _ in 0..<recipeArray.count {
//        //            print("Doing shit!")
//        //            imageArray.append(#imageLiteral(resourceName: "errorstop"))
//        //        }
//        self.tableView.reloadData()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return recipeArray.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let currentRecipe = recipeArray[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
//        cell.cellLabel.text = currentRecipe.name
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        var convertedDate = dateFormatter.string(from: currentRecipe.dateAdded! as Date)
//        cell.dateAddedCell.text = convertedDate
//        cell.cellRatingLabel.text = ratingToStarsForLabel(rating: currentRecipe.rating)
//        cell.cellRecipeImage?.image = nil
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedRecipe = recipeArray[indexPath.row]
//        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "tablePressed", sender: self)
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "tablePressed" {
//            let destinaton = segue.destination as! TableViewPressedViewController
//            destinaton.selectedRecipe = selectedRecipe
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let deleteIndexPath = indexPath
//            let rowToDelete = recipeArray[deleteIndexPath.row]
//            recipeArray.remove(at: indexPath.row)
//            store.delete(recipe: rowToDelete)
//            tableView.reloadData()
//        }
//    }
//
//
//
//
//
//    func ratingToStarsForLabel(rating: Int16) -> String {
//
//        switch rating {
//        case 0:
//            return "No Rating!"
//        case 1:
//            return "⭐️"
//        case 2:
//            return "⭐️⭐️"
//        case 3:
//            return "⭐️⭐️⭐️"
//        case 4:
//            return "⭐️⭐️⭐️⭐️"
//        case 5:
//            return "⭐️⭐️⭐️⭐️⭐️"
//        default:
//            return "No Rating!"
//        }
//
//    }
//
//
//}

