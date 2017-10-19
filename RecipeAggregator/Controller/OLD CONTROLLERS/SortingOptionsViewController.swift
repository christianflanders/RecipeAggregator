//
//  SortingOptionsViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/28/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class SortingOptionsViewController: UIViewController {
    
    
    
    var sortingButtonSelected: SortBy?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func filterByDateButton(_ sender: UIButton) {
        sortingButtonSelected = .date
        performSegue(withIdentifier: "sortingButtonPressed", sender: nil)
    }
    
    @IBAction func sortByRatingButton(_ sender: UIButton) {
        sortingButtonSelected = .rating
        performSegue(withIdentifier: "sortingButtonPressed", sender: nil)

    }
    
    @IBAction func sortByMealButton(_ sender: UIButton) {
        
    }
    
    @IBAction func filterByNameButton(_ sender: UIButton) {
        sortingButtonSelected = .name
        performSegue(withIdentifier: "sortingButtonPressed", sender: nil)

    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sortingButtonPressed" {
            let destination = segue.destination as! RecipeTableViewController
            if sortingButtonSelected != nil {
                destination.whatToSortBy = sortingButtonSelected!
            }
        }
    }


}
