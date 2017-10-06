//
//  AddItemViewController.swift
//  MyShoppingListDB
//
//  Created by DrKeng on 9/16/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var myShoppingItem : NSManagedObject?
    
    var myItemCategoriesList : [AnyObject]? = []
    
//    let SwipLeft = UISwipeGestureRecognizer.
//    let SwipeLeft = UISwipeGestureRecognizerDirection
//    let SwipeLeft = UISwipeActionsConfiguration
    
    @IBOutlet weak var txtShoppingItem: UITextField!
    @IBOutlet weak var txtUnitPrice: UITextField!
    @IBOutlet weak var txtNumberOfItems: UITextField!
    
    @IBOutlet weak var pickerViewItemCategory: UIPickerView!
    
    @IBAction func saveShoppingItemMethod() {
        //สร้าง Object ของ AppDelegate เพื่อเรียกใช้ persistentContainer
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        
        //Read Data from ItemCategory to PickerView
        let mySelectedItemCategory = pickerViewItemCategory.selectedRow(inComponent: 0)
        let myItemCategory = myItemCategoriesList![mySelectedItemCategory]
        
        
        //เช็คว่าเป็นการ Update ข้อมูลหรือสร้างใหม่
        if myShoppingItem != nil{
            myShoppingItem?.setValue(txtShoppingItem.text!, forKey: "itemName")
            myShoppingItem?.setValue(Float(txtUnitPrice.text!)!, forKey: "itemPrice")
            myShoppingItem?.setValue(Int(txtNumberOfItems.text!)!, forKey: "itemNumber")
            myShoppingItem?.setValue(1, forKey: "itemStatus")
            
            //Add ItemCategory Data
            myShoppingItem?.setValue(myItemCategory, forKey: "itemCategory")
        }
        else{
            //สร้าง Object ข้อมูล ShoppingItem ของ Core Data
            let newShoppingItem = NSEntityDescription.insertNewObject(forEntityName: "ShoppingItem", into: myContext)
            newShoppingItem.setValue(txtShoppingItem.text!, forKey: "itemName")
            newShoppingItem.setValue(Float(txtUnitPrice.text!)!, forKey: "itemPrice")
            newShoppingItem.setValue(Int(txtNumberOfItems.text!)!, forKey: "itemNumber")
            newShoppingItem.setValue(1, forKey: "itemStatus")
            
            //Add ItemCategory Data
            newShoppingItem.setValue(myItemCategory, forKey: "itemCategory")
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
        
        pickerViewItemCategory.dataSource = self
        pickerViewItemCategory.delegate = self
        
        // Read Data of Item Category
        readItemCategoryFromDB()
        
        if myItemCategoriesList == nil {
            
            let myAlert = UIAlertController(title: "MyShoppingListDB", message: "Please create Item Category first", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            myAlert.addAction(okButton)
            self.present(myAlert, animated: true, completion: nil)

            
        }else{
        if myShoppingItem != nil {
            let myItemName = myShoppingItem?.value(forKey: "itemName") as! String
            let myItemNumber = myShoppingItem?.value(forKey: "itemNumber") as! Int
            let myUnitePrice = myShoppingItem?.value(forKey: "itemPrice") as! Float
            
            //Read ItemCategory from Shopping Item
            let myItemCategory = myShoppingItem?.value(forKey: "itemCategory") as! NSManagedObject
            
            txtShoppingItem.text = myItemName
            txtUnitPrice.text = String(myUnitePrice)
            txtNumberOfItems.text = String(myItemNumber)
            
            //Find index of ItemCategory to spin PickerView
            let myItemCategoryRow = myItemCategoriesList?.index{$0 === myItemCategory}
                pickerViewItemCategory.selectRow(myItemCategoryRow!, inComponent: 0, animated: true)
            }
        }
    }

    func readItemCategoryFromDB(){

        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext

        let myFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCategory")
        
        do{
            myItemCategoriesList = try myContext.fetch(myFetchRequest)
        }catch let error as NSError{
            print(error.description)
        }
        
    }
    
    //MARK: Picker Datasource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myItemCategoriesList!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 60))
        let myImageView = UIImageView(frame: CGRect(x: 25, y: 0, width: 60, height: 60))
        let myLabel = UILabel(frame: CGRect(x: 95, y: 0, width: pickerView.bounds.width - 90, height: 60))
        let myItemCategory = myItemCategoriesList![row]
        let logo = myItemCategory.value(forKey: "categoryImage") as! Data
        
        myLabel.text = myItemCategory.value(forKey: "categoryName") as? String
        myImageView.image = UIImage(data: logo)
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        return myView
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
