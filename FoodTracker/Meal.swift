//
//  Meal.swift
//  FoodTracker
//
//  Created by AJ Canepa on 12/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int)
    {
        // check validity of incoming parameters before initializing
        if name.isEmpty {
            return nil
        }
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
