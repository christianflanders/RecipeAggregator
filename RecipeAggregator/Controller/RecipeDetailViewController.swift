//
//  RecipeDetailViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 10/19/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    //MARK: Enums
    
    //MARK: Constants
    
    //MARK: Variables
    
    //MARK: Outlets
    
    @IBOutlet weak var recipeImagePreview: UIImageView!
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    lazy var selectedRecipe = RecipeFromURL()
    //MARK: Private Variables
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNameLabel.text = selectedRecipe.name
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: IBActions
    
    //MARK: Instance Methods
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenRecipeInWebView" {
            let destinationVC = segue.destination as! WebViewController
            if let url = selectedRecipe.url {
                destinationVC.url = url
            }
            
        }
        
        
    }
    
    
    
}
