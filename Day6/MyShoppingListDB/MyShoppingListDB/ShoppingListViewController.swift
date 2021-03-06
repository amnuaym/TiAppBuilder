//
//  ShoppingListViewController.swift
//  MyShoppingListDB
//
//  Created by DrKeng on 9/16/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //ตัวแปรสำหรับเก็บข้อมูล List ของ ShoppingItems
    var myShoppingItemsList : [AnyObject]? = []
    
    //Add Variables for Item Category store
    var myItemCategoriesList : [AnyObject]? = []
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK: Customized SegmentedControl Methods
    func customizedSegmentedControlTab(){
        //Delete All Segments
        mySegmentedControl.removeAllSegments()
        
        //Add first segment and some more
        mySegmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        for myIndex in 0..<myItemCategoriesList!.count{
        let myItemCategory = myItemCategoriesList![myIndex]
            let myItemName = myItemCategory.value(forKey: "CategoryName") as! String
            mySegmentedControl.insertSegment(withTitle: myItemName, at: myIndex + 1, animated: false)
        }
    }
    
    func displayShoppingItemsByItemCategory (categoryNumber : Int){
        // Create AppDelegate Object to enable PersistentContainer(Core Data) Access
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext

        let myFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        
        if categoryNumber != 0 {
            let myItemCategory = myItemCategoriesList![categoryNumber - 1] as! NSManagedObject
            //Specifiy Data Query
            let myPredicate = NSPredicate(format: "itemCategory = %@", myItemCategory)
            myFetchRequest.predicate = myPredicate
        }
        
        do{
            myShoppingItemsList = try myContext.fetch(myFetchRequest)
        }catch let error as NSError{
            print(error.description)
        }
        self.myTableView.reloadData()
    }
    
    
    
    @IBAction func selectSegmentMethod() {
        let mySelection = mySegmentedControl.selectedSegmentIndex
        self.displayShoppingItemsByItemCategory(categoryNumber: mySelection)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Shopping List"
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //สร้าง Object ของ AppDelegate เพื่อเรียกใช้ persistentContainer
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        
        let myFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        
        //Add Fetch data by Category
        let myCategodyFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemCategory")

        
        do{
            myShoppingItemsList = try myContext.fetch(myFetchRequest)
            
            //Read Iteam Category from Database
            myItemCategoriesList = try myContext.fetch(myCategodyFetchRequest)

        }catch let error as NSError{
            print(error.description)
        }
        self.myTableView.reloadData()
        self.customizedSegmentedControlTab()
        mySegmentedControl.selectedSegmentIndex = 0


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myShoppingItemsList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let myShoppingItem : NSManagedObject = myShoppingItemsList![indexPath.row] as! NSManagedObject
        let myItemName = myShoppingItem.value(forKey: "itemName") as! String
        let myItemNumber = myShoppingItem.value(forKey: "itemNumber") as! Int
        let myItemPrice = myShoppingItem.value(forKey: "itemPrice") as! Float
        let myItemStatus = myShoppingItem.value(forKey: "itemStatus") as! Int
        
        //เช็ค Status เพื่อเปลี่ยนสีของ Font
        if myItemStatus == 0 {
            cell.textLabel?.textColor = UIColor.orange
            cell.detailTextLabel?.textColor = UIColor.orange
        }
        else{
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        }
        
        cell.textLabel?.text = myItemName
        cell.detailTextLabel?.text = "จำนวน \(myItemNumber) | ราคาต่อหน่วย \(myItemPrice) บาท"
        
        return cell
    }
    
    //สร้างปุ่ม (Action) ในแต่ละ Row และกำหนดฟังก์ชันการทำงาน
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
                print("delete at:\(indexPath)") //Log ดูที่ Console
                self.deleteRowFromTableView(tableView, indexPath: indexPath)
            }
        delete.backgroundColor = UIColor.red
        
        let done = UITableViewRowAction(style: .default, title: "Done") { (action:UITableViewRowAction, indexPath:IndexPath) in
                print("done at:\(indexPath)")
                self.updateItemInTableView(tableView, indexPath: indexPath)
            }
        done.backgroundColor = UIColor.orange
        
//        let button1 = UITableViewRowAction(style: .default, title: "button1") { (action:UITableViewRowAction, indexPath:IndexPath) in
//        }
//
//        let button2 = UITableViewRowAction(style: .default, title: "button2") { (action:UITableViewRowAction, indexPath:IndexPath) in
//        }
//        let button3 = UITableViewRowAction(style: .default, title: "button3") { (action:UITableViewRowAction, indexPath:IndexPath) in
//        }
//
//        let button4 = UITableViewRowAction(style: .default, title: "button4") { (action:UITableViewRowAction, indexPath:IndexPath) in
//        }
        
//        return [delete, done, button1, button2, button3, button4]
        return [delete, done]
    }
    
    //ฟังก์ชันที่ถูกเรียกเมื่อกดปุ่ม Delete
    func deleteRowFromTableView (_ tableView: UITableView, indexPath: IndexPath){
        //สร้าง Object ของ AppDelegate เพื่อเรียกใช้ persistentContainer
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        
        //ลบข้อมูลออกจาก NSManagedObject
        myContext.delete(myShoppingItemsList![indexPath.row] as! NSManagedObject)
        
        //ลบข้อมูลออกจาก Datasource Array
        myShoppingItemsList!.remove(at: indexPath.row)
        
        // Delete the row from the data source
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        //บันทึกการลบข้อมูล
        do{
            try myContext.save()
            print("ลบข้อมูลแล้ว!")
        }catch let error as NSError{
            print(error.description + " : ไม่สามารถบันทึกการลบข้อมูลได้")
        }
    }
    
    func updateItemInTableView(_ tableView: UITableView, indexPath: IndexPath){
        
        let selectedItem : NSManagedObject = myShoppingItemsList![indexPath.row] as! NSManagedObject
        
        
        //สร้าง Object ของ AppDelegate เพื่อเรียกใช้ persistentContainer
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        
        selectedItem.setValue(0, forKey: "itemStatus")
        
        //บันทึกลงฐานข้อมูล
        do{
            try myContext.save()
            print("บันทึกข้อมูลแล้ว!")
        }catch let error as NSError{
            print(error.description + " : ไม่สามารถบันทึกข้อมูลได้")
        }
        
        
        //Refresh ข้อมูลใน TableView
        let myFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShoppingItem")
        
        
        do{
            myShoppingItemsList = try myContext.fetch(myFetchRequest)
            
        }catch let error as NSError{
            print(error.description)
        }
        
        tableView.reloadData()
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateSegue"{
            let indexPath = self.myTableView.indexPathForSelectedRow!
            let selectedItem : NSManagedObject = myShoppingItemsList![indexPath.row] as! NSManagedObject
            let myAddItemViewController = segue.destination as! AddItemViewController
            myAddItemViewController.myShoppingItem = selectedItem
        }
    }
}

