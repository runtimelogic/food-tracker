//
//  Meal.swift
//  FoodTracker
//
//  Created by AJ Canepa on 12/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    // MARK: Types
    
    struct PropertyKey
    {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    
    // MARK: Initialization
    
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
    
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        // name is required - if we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // photo is an optional property of Meal - use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // convenience init must call a designated init
        self.init(name: name, photo: photo, rating: rating)
    }
    
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
}
