//
//  MealViewController.swift
//  FoodTracker
//
//  Created by AJ Canepa on 12/14/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var _meal: Meal?
    
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // handle the text field’s user input through delegate callbacks
        nameTextField.delegate = self
        
        // init controls if meal data present
        if let meal = _meal
        {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // enable the Save button only if the text field has a valid Meal name
        self.updateSaveButtonState()
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hide the keyboard
        nameTextField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // the info dictionary may contain multiple representations of the image - use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        _meal = Meal(name: (nameTextField.text ?? ""), photo: photoImageView.image, rating: ratingControl.rating)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        // depending on style of presentation (modal or push presentation), this view controller needs to be dismissed  differently
        let isPresentingInAddMealMode = self.presentingViewController is UINavigationController
        if isPresentingInAddMealMode
        {
            self.dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = self.navigationController
        {
            owningNavigationController.popViewController(animated: true)
        }
        else
        {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        // only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Helper Methods
    
    private func updateSaveButtonState() {
        // disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

