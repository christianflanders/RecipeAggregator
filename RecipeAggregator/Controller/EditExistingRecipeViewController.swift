//
//  EditExistingRecipeViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/27/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class EditExistingRecipeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let store = PersistanceService.store
    var nameChanged = false
    var oldRecipeName = ""
    var mealChanged = false
    
    private let picker = UIImagePickerController()
    private let camera = UIImagePickerController()
    

    var selectedRecipe:RecipeFromURL?
    let mealSelection = ["Breakfast", "Lunch", "Dinner", "Snacks", "Other"]
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ratingSliderOutlet: UISlider!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var mealSegementedControl: UISegmentedControl!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNameTextField.placeholder = selectedRecipe?.name

        recipeNameTextField.delegate = self
        picker.delegate = self
        camera.delegate = self
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameChanged = true
        oldRecipeName = (selectedRecipe?.name)!
        
    }
    
    
    @IBAction func ratingSlider(_ sender: UISlider) {
        let currentValue = ratingSliderOutlet.value
        selectedRecipe?.rating = Int16(currentValue)
        ratingLabel.text = String(currentValue)
    }
  
    
    
    @IBAction func mealSegmentedControlPressed(_ sender: UISegmentedControl) {
        selectedRecipe?.meal = mealSelection[mealSegementedControl.selectedSegmentIndex]
    }
    
    @IBAction func selectNewImageButton(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        recipeImage.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if nameChanged == true {
            selectedRecipe?.name = recipeNameTextField.text
        }
        print("leaving editing mode")
        store.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
