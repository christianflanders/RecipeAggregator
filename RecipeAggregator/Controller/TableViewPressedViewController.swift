//
//  TableViewPressedViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/27/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class TableViewPressedViewController: UIViewController {
    
    var selectedRecipe: RecipeFromURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func viewRecipeButton(_ sender: UIButton) {
   
    }
    
    
    @IBAction func editRecipeButton(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedRecipe = selectedRecipe {
            if segue.identifier == "viewRecipeButton" {
                let nav = segue.destination as! UINavigationController
                let destination = nav.topViewController as! WebViewController
                destination.url = selectedRecipe.url!
            } else if segue.identifier == "editRecipeButtonPressed"{
                let nav = segue.destination as! UINavigationController
                let destination = nav.topViewController as! EditExistingRecipeViewController
                destination.selectedRecipe = selectedRecipe
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
