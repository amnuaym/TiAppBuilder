//
//  RestaurantListTableViewController.swift
//  RateMyRestaurant
//
//  Created by Worasit Choochaiwattana on 11/25/2559 BE.
//  Copyright © 2559 Worasit Choochaiwattana. All rights reserved.
//

import UIKit
import CloudKit

class RestaurantListTableViewController: UITableViewController {

    var restaurantsList : [CKRecord]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rate My Restaurant"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    //MARK: Fetch data from iCloud
    func fetchRestaurantInfoListFromiCloud(){

        //Create Activity Indicator and order it to show
        let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        myActivityIndicator.activityIndicatorViewStyle = .gray
        myActivityIndicator.center = (self.navigationController?.view.center)!
        myActivityIndicator.startAnimating()
        myActivityIndicator.backgroundColor = UIColor.white
        self.view.addSubview(myActivityIndicator)
        
        //Create Container variable and specify Database
                let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        let myPredicate = NSPredicate(value: true)
        
        let myQuery = CKQuery(recordType: "MyRestaurant", predicate: myPredicate)
        publicDatabase.perform(myQuery, inZoneWith: nil) { (results, error) in
            if error != nil{
                print(error!)
            }else{
                print(results!)
                OperationQueue.main.addOperation {
                    self.restaurantsList!.removeAll()
                    for result in results!{
                        self.restaurantsList?.append(result)
                        myActivityIndicator.stopAnimating()
                        myActivityIndicator.hidesWhenStopped = true
                        }
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchRestaurantInfoListFromiCloud()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantsList!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell
        let restaurantRecord = restaurantsList![indexPath.row]

        // Configure the cell...
        cell.lblRestaurantName.text = restaurantRecord.value(forKey: "restaurantName") as? String
        cell.lblRestaurantLocation.text = restaurantRecord.value(forKey: "restaurantLocation") as? String
        
        //Calculate vote score
        let numberOfVoters = restaurantRecord.value(forKey: "restaurantNumberOfVoters") as? Int
        var ratingScore : Double = 0.0
        
        if numberOfVoters! > 0 {
            let totalScore = restaurantRecord.value(forKey: "restaurantTotalScore") as? Int
            ratingScore = Double(totalScore!) / Double(numberOfVoters!)
        }else{
            ratingScore = 0.0
        }
        
        cell.lblRatingScore.text = "Vote Score \(ratingScore)"
        
        //Display image in ImageView
        let restaurantImageAsset : CKAsset = (restaurantRecord.value(forKey: "restaurantImage") as? CKAsset)!
        cell.imgRestaurant.image = UIImage(contentsOfFile: restaurantImageAsset.fileURL.path)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow!
        let myVC = segue.destination as! RateRestaurantViewController
        myVC.voteRestaurantRecord = restaurantsList![indexPath.row]
    }

}
