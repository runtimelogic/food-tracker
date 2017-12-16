//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by AJ Canepa on 12/14/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase
{
    // MARK: Meal Class Tests

    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitSucceeds()
    {
        // zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testMealInitFails()
    {
        // negative rating
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
}
