//
//  MainSelectionTableViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class MainSelectionTableViewController: UITableViewController {
    
    
    //MARK: Enums
    
    //MARK: Constants
    let tableViewOptions = ["Breakfast", "Lunch", "Dinner", "Snacks", "Favorites","Unsorted", "All"]
    let tableViewColors = [UIColor.init(red: 251/255, green: 110/255, blue: 82/255, alpha: 1),UIColor.init(red: 255/255, green: 207/255, blue: 85/255, alpha: 100),UIColor.init(red: 160/255, green: 212/255, blue: 104/255, alpha: 1),UIColor.init(red: 72/255, green: 207/255, blue: 174/255, alpha: 100),UIColor.init(red: 79/255, green: 192/255, blue: 232/255, alpha: 1), UIColor.init(red: 93/255, green: 155/255, blue: 236/255, alpha: 100),UIColor.init(red: 172/255, green: 146/255, blue: 237/255, alpha: 100)]
    let tableViewImages = [#imageLiteral(resourceName: "Breakfast Icon 2x"),#imageLiteral(resourceName: "Lunch icon 2x"),#imageLiteral(resourceName: "Dinner Icon 2x"),#imageLiteral(resourceName: "Snacks Icon 2x"),#imageLiteral(resourceName: "Favorites Icon 2x"),#imageLiteral(resourceName: "Unlabled Icon 2x"),#imageLiteral(resourceName: "All Recipes icon 2x")]
    //MARK: Variables
    var rowSelected = ""
    //MARK: Outlets
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    
    //MARK: Private Variables
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = (view.frame.height  / 9)
        tableView.isScrollEnabled = false
        
    }
    //MARK: IBActions
    
    //MARK: Instance Methods
    
//    func checkCellAndAddColor(cellName: String) -> UIColor {
//        
//        
//    }
//    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewOptions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text = tableViewOptions[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = tableViewColors[indexPath.row]
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.image = tableViewImages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //depending on the text label of the cell, pass that information back on to the next table view controller to grab the appropriate items from CoreData
        rowSelected = tableViewOptions[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CategoryRowSelectedSegue", sender: self)
        
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryRowSelectedSegue" {
            let destination = segue.destination as! CategoryRowSelectedTableViewController
            destination.categorySelected = rowSelected
        }
    }
    
}
