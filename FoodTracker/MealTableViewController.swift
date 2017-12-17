//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by AJ Canepa on 12/17/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController
{
    // MARK: Properties
    
    var meals = [Meal]()
    
    
    // MARK: Initialization
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // load the sample data
        self.loadSampleMeals()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let mealTableViewCell = cell as? MealTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }

        // fetch the appropriate meal for the data source layout
        let meal = meals[indexPath.row]
        mealTableViewCell.nameLabel.text = meal.name
        mealTableViewCell.photoImageView.image = meal.photo
        mealTableViewCell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue)
    {
        if let sourceViewController = sender.source as? MealViewController,
            let meal = sourceViewController.meal
        {
            // add a new meal
            let newIndexPath = IndexPath(row: self.meals.count, section: 0)
            self.meals.append(meal)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Helper Methods
    
    private func loadSampleMeals ()
    {
        struct mealStruct {
            var name: String
            var photo: String
            var rating: Int
        }
        let mealData: [mealStruct] = [mealStruct(name: "Caprese Salad", photo: "meal1", rating: 4),
                                      mealStruct(name: "Chicken and Potatoes", photo: "meal2", rating: 5),
                                      mealStruct(name: "Pasta with Meatballs", photo: "meal3", rating: 3)]
        
        for item in mealData {
            let image = UIImage(named: item.photo)
            guard let meal = Meal(name: item.name, photo: image, rating: item.rating) else {
                fatalError("Unable to instantiate meal")
            }
            
            meals.append(meal)
        }
    }
}
