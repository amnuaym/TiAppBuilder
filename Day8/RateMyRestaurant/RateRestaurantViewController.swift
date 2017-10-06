//
//  RateRestaurantViewController.swift
//  RateMyRestaurant
//
//  Created by Worasit Choochaiwattana on 11/25/2559 BE.
//  Copyright © 2559 Worasit Choochaiwattana. All rights reserved.
//

import UIKit
import CloudKit

class RateRestaurantViewController: UIViewController {
    //Variable for Voted Restaurant
    var voteRestaurantRecord : CKRecord?
    
    //Variable for Raing Score
    var numberOfVoters : Int = 0
    var totalScore : Int = 0
    var ratingScore : Double = 0.0
    
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantLocation: UILabel!
    @IBOutlet weak var segmentedRating: UISegmentedControl!
    
    
    @IBAction func submitVoteMethod() {
        numberOfVoters += 1
        totalScore += segmentedRating.selectedSegmentIndex + 1
//        ratingScore = Double(totalScore) / Double(numberOfVoters)
        
        voteRestaurantRecord!.setObject(numberOfVoters as CKRecordValue, forKey: "restaurantNumberOfVoters")
        voteRestaurantRecord!.setObject(totalScore as CKRecordValue, forKey: "restaurantTotalScore")
        
        //Create Container valriable and Specify Database
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        publicDatabase.save(voteRestaurantRecord!) { (myrecord, error) in
            if error != nil{
                    print(error!)
            }else{
                OperationQueue.main.addOperation {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelMethod() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lblRestaurantName.text = voteRestaurantRecord!.value(forKey: "restaurantName") as? String
        lblRestaurantLocation.text = voteRestaurantRecord!.value(forKey: "restaurantLocation") as? String
        
        numberOfVoters = voteRestaurantRecord!.value(forKey: "restaurantNumberOfVoters") as! Int
        totalScore = voteRestaurantRecord!.value(forKey: "restaurantTotalScore") as! Int
        
        let restaurantImageAsset : CKAsset = voteRestaurantRecord!.value(forKey: "restaurantImage") as! CKAsset
        imgRestaurant.image = UIImage(contentsOfFile: restaurantImageAsset.fileURL.path)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
