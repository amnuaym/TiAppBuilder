//
//  ItemCategoryViewController.swift
//  MyShoppingListDB
//
//  Created by Amnuay M on 9/18/17.
//  Copyright © 2017 ANT. All rights reserved.
//

import UIKit
import CoreData

class ItemCategoryViewController: UIViewController {

    let logoList : [String] = ["1.png", "2.png", "3.png", "4.png", "5.png"]
    var currentLogo : Int = 0
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtItemCategoryName: UITextField!

    
    @IBAction func saveItemCategoryMethod(_ sender: Any) {
    // Create AppDelegate Object to enable PersistentContainer(Core Data) Access
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    let myContext = myAppDelegate.persistentContainer.viewContext
        
    // Create Object of ItemCategory Entity from Core Data
    let newItemCategory = NSEntityDescription.insertNewObject(forEntityName: "ItemCategory", into: myContext)
        
    let theCategoryImageData = UIImagePNGRepresentation(imgLogo.image!)! as Data
    newItemCategory.setValue(txtItemCategoryName.text!, forKey: "categoryName")
    newItemCategory.setValue(theCategoryImageData, forKey: "categoryImage")
    
        //MARK: Save into Core Data
        do{
            try myContext.save()
            print("### Data Saved ###")
        } catch let error as NSError{
            print(error.description + " : Cannot Save Data")
        }
    
        //MARK: Back to main ViewController with popViewController
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func handleSwipeLeftMethod(_ sender: Any) {
        currentLogo += 1
        if currentLogo > 4 {
            currentLogo = 0
        }
        imgLogo.image = UIImage(named: logoList[currentLogo])
    }
    
    @IBAction func handleSwipeRightMethod(_ sender: Any) {
        currentLogo -= 1
        if currentLogo < 0 {
            currentLogo = 4
        }
        imgLogo.image = UIImage(named: logoList[currentLogo])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
