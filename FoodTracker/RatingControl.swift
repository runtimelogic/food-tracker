//
//  RatingControl.swift
//  FoodTracker
//
//  Created by AJ Canepa on 12/15/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView
{
    //MARK: Properties
    private var ratingButtons: [UIButton] = [UIButton]()
    
    var _rating: Int = 0 {
        didSet {
            self.updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            self.setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            self.setupButtons()
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButtons()
    }
    

    // MARK: Actions
    
    @objc func ratingButtonPress(button: UIButton)
    {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // calculate the rating of the selected button
        let selectedRating = index + 1
        if selectedRating == _rating {
            // the pressed star represents the current rating - reset the rating to 0
            _rating = 0
        } else {
            // set the rating to the selected star
            _rating = selectedRating
        }
    }
    
    
    // MARK: Helper Methods
    
    private func setupButtons()
    {
        // clear any existing buttons
        for button in ratingButtons {
            self.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // load button images
        let bundle = Bundle(for: type(of: self))
        let imageStarNormal = UIImage(named:"ratingStar-empty", in: bundle, compatibleWith: self.traitCollection)
        let imageStarFilled = UIImage(named: "ratingStar-filled", in: bundle, compatibleWith: self.traitCollection)
        let imageStarHighlight = UIImage(named:"ratingStar-highlight", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            
            // set the button images
            button.setImage(imageStarNormal, for: .normal)
            button.setImage(imageStarFilled, for: .selected)
            button.setImage(imageStarHighlight, for: .highlighted)
            button.setImage(imageStarHighlight, for: [.highlighted, .selected])
            
            // add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // create action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonPress(button:)), for: .touchUpInside)
            
            // add the button to the stack
            self.addArrangedSubview(button)
            
            // add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        self.updateButtonSelectionStates()
    }
    
    
    private func updateButtonSelectionStates ()
    {
        // determine the accessibility value string based on the rating
        let valueString: String
        switch (_rating) {
        case 0:
            valueString = "No rating set."
        case 1:
            valueString = "1 star set."
        default:
            valueString = "\(_rating) stars set."
        }
        
        for (index, button) in ratingButtons.enumerated() {
            // if the index of a button is less than the rating, that button should be selected
            button.isSelected = index < _rating
            
            // set the accessibility hint string for the currently selected star
            let hintString: String?
            if _rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
