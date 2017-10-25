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
    
    let picker = UIImagePickerController()
    let camera = UIImagePickerController()
    private let alertController = UIAlertController(title: "Update Image", message: nil, preferredStyle: .actionSheet)
    
    
    var selectedRecipe:RecipeFromURL?
    let mealSelection = ["Breakfast", "Lunch", "Dinner", "Snacks", "Other"]
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var ratingSliderOutlet: UISlider!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var mealSegementedControl: UISegmentedControl!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    let storedImages = StoredImages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeNameTextField.placeholder = selectedRecipe?.name
        
        recipeNameTextField.delegate = self
        picker.delegate = self
        camera.delegate = self
        let cameraAction = UIAlertAction(title: "Use Camera", style: .default) { action in
            self.present(self.camera, animated: true, completion: nil)
        }
        let library = UIAlertAction(title: "Use Library", style: .default) { action in
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(library)
        alertController.addAction(cancel)
        
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
        present(alertController, animated: true, completion: nil)
        //        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipeImage.image = image
        storedImages.storeImageInUserDefaults(image: image, location: (selectedRecipe?.url!)!)
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
