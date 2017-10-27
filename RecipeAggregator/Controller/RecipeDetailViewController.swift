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
    @IBOutlet weak var notesPreview: UITextView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    //MARK: Weak Vars
    
    //MARK: Public Variables
    var selectedRecipe = RecipeFromURL()
    var recipeImage: UIImage?
    
    //MARK: Private Variables
    
    //MARK: View Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        reloadRecipeInformation()
    }
    
    
    //MARK: IBActions
    
    //MARK: Instance Methods
    
    func reloadRecipeInformation() {
        recipeNameLabel.text = selectedRecipe.name
        if let notes = selectedRecipe.notes {
            notesPreview.text = notes
        } else {
            notesPreview.text = "No notes added"
        }
        recipeImagePreview.image = recipeImage
        if recipeImage == nil {
            DispatchQueue.global(qos: .background).async {
                let stored = StoredImages()
                if let storedImage = stored.grabImageFromUserDefaults(location: self.selectedRecipe.url!) {
                    self.recipeImagePreview.image = storedImage
                }
                if let previewURL = stored.getPreviewImageURLFromHTML(url: self.selectedRecipe.url!) {
                    let image = stored.downloadImageFromURL(previewURL)
                    DispatchQueue.main.async {
                        self.recipeImagePreview.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.recipeImagePreview.image = #imageLiteral(resourceName: "errorstop")
                    }
                }
                
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenRecipeInWebView" {
            let destinationVC = segue.destination as! WebViewController
            if let url = selectedRecipe.url {
                destinationVC.url = url
            }
        } else if segue.identifier == "EditRecipeSegue" {
            let destinationVC = segue.destination as! EditExistingRecipeViewController
            destinationVC.selectedRecipe = selectedRecipe
            destinationVC.selectedRecipeImage = recipeImagePreview.image!
        }
        
        
    }
    
    
    
}
