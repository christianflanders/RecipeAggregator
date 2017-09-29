//
//  EditExistingRecipeViewController.swift
//  RecipeAggregator
//
//  Created by Christian Flanders on 9/27/17.
//  Copyright © 2017 Christian Flanders. All rights reserved.
//

import UIKit

class EditExistingRecipeViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let store = PersistanceService.store
    var nameChanged = false
    var oldRecipeName = ""
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return mealSelection.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    

    var selectedRecipe:RecipeFromURL?
    let mealSelection = ["Breakfast", "Lunch", "Dinner", "Snacks", "Drinks"]
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ratingSliderOutlet: UISlider!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var mealPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNameTextField.placeholder = selectedRecipe?.name
        mealPicker.delegate = self
        mealPicker.dataSource = self
        recipeNameTextField.delegate = self
        
        
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
  
    
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if nameChanged == true {
            selectedRecipe?.name = recipeNameTextField.text
        }
        print("leaving editing mode")
        store.saveContext()
        
    }
    
    
    
    
    
}
