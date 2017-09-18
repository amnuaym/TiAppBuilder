//
//  AddItemViewController.swift
//  MyShoppingListDB
//
//  Created by DrKeng on 9/16/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController {
    
    var myShoppingItem : NSManagedObject?
    
    @IBOutlet weak var txtShoppingItem: UITextField!
    @IBOutlet weak var txtUnitPrice: UITextField!
    @IBOutlet weak var txtNumberOfItems: UITextField!
    
    
    @IBAction func saveShoppingItemMethod() {
        //สร้าง Object ของ AppDelegate เพื่อเรียกใช้ persistentContainer
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        
        //เช็คว่าเป็นการ Update ข้อมูลหรือสร้างใหม่
        if myShoppingItem != nil{
            myShoppingItem?.setValue(txtShoppingItem.text!, forKey: "itemName")
            myShoppingItem?.setValue(Float(txtUnitPrice.text!)!, forKey: "itemPrice")
            myShoppingItem?.setValue(Int(txtNumberOfItems.text!)!, forKey: "itemNumber")
            myShoppingItem?.setValue(1, forKey: "itemStatus")
        }
        else{
            //สร้าง Object ข้อมูล ShoppingItem ของ Core Data
            let newShoppingItem = NSEntityDescription.insertNewObject(forEntityName: "ShoppingItem", into: myContext)
            newShoppingItem.setValue(txtShoppingItem.text!, forKey: "itemName")
            newShoppingItem.setValue(Float(txtUnitPrice.text!)!, forKey: "itemPrice")
            newShoppingItem.setValue(Int(txtNumberOfItems.text!)!, forKey: "itemNumber")
            newShoppingItem.setValue(1, forKey: "itemStatus")
        }
        
        //บันทึกลงฐานข้อมูล
        do{
            try myContext.save()
            print("บันทึกข้อมูลแล้ว!")
        }catch let error as NSError{
            print(error.description + " : ไม่สามารถบันทึกข้อมูลได้")
        }
        
        //กลับไปหน้าหลัก
        navigationController?.popViewController(animated: true)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        if myShoppingItem != nil {
            let myItemName = myShoppingItem?.value(forKey: "itemName") as! String
            let myItemNumber = myShoppingItem?.value(forKey: "itemNumber") as! Int
            let myUnitePrice = myShoppingItem?.value(forKey: "itemPrice") as! Float
            
            txtShoppingItem.text = myItemName
            txtUnitPrice.text = String(myUnitePrice)
            txtNumberOfItems.text = String(myItemNumber)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
