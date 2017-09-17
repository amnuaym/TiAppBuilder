//
//  RateStudentViewController.swift
//  RateMyStudentDB
//
//  Created by Amnuay M on 9/11/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import CoreData

class RateStudentViewController: UIViewController {
    var theStudent : Student = Student()
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblRatingScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = theStudent.StudentName
        imgView.image = theStudent.StudentImage
        lblRatingScore.text = "\(theStudent.StudentRatingScore)"
    }

    func saveStudentRecord() -> Void{
        //Create Object from AppDelegate to enable persistentContainer call
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        
        //Fetch data to be updated from database
        let myFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentTB")
        myFetchRequest.returnsObjectsAsFaults = false
        
        //Specify data to be collected
        let myPredicate = NSPredicate(format: "studentName == %@", theStudent.StudentName)
        myFetchRequest.predicate = myPredicate
        
        do{
            let myFetchResults = try myContext.fetch(myFetchRequest)
            if myFetchResults.count > 0 {
                let myResult = myFetchResults.first as! NSManagedObject
                
                //Update data in Object
                myResult.setValue(theStudent.StudentName, forKey: "studentName")
                myResult.setValue(theStudent.StudentRatingScore, forKey: "studentRatingScore")
                let theImageData = UIImagePNGRepresentation(theStudent.StudentImage)! as NSData
                myResult.setValue(theImageData, forKey: "studentImage")
            }
        }catch let error as NSError{
            print(error.description)
        }
        
        //Save Database update
        do{
            try myContext.save()
        }catch let error as NSError{
            print(error.description)
        }
        
        //Going back to Main View Controller (popViewController) need guard syntax as it prevent mistake from error of no Navigation Controller
        
        guard ((navigationController?.popViewController(animated: true)) != nil) else {
            print ("No Navigation Controller")
            return
        }
    }
    
    @IBAction func addScoreMethod() {
        theStudent.addRatingScore(ratingScore: 10)
        saveStudentRecord()
    }
    
    @IBAction func minusScoreMethod() {
        theStudent.minusRatingScore(ratingScore: 10)
        saveStudentRecord()
    }
    
    @IBAction func resetScoreMethod() {
        theStudent.resetRatingScore()
        saveStudentRecord()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

