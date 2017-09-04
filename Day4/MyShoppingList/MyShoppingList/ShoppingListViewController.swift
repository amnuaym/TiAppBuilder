//
//  ShoppingListViewController.swift
//  MyShoppingList
//
//  Created by Amnuay M on 9/4/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShoppingItemViewControllerDelegate {

    var myShoppingList : [ShoppingItem] = []
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "MyShoppingList"
        myTableView.delegate = self
        myTableView.dataSource = self
        self.navigationItem.leftBarButtonItem = editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        myTableView.setEditing(editing, animated: true)

//        @AM below cannot be use... editing is a boolean variable toggle by Edit button.
//        super.setEditing(true, animated: true)
//        myTableView.setEditing(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addShoppingItem(newShoppingItem: ShoppingItem, newItem: Int) {
        if newItem == -1 {
            myShoppingList.append(newShoppingItem)
        }else {
            myShoppingList[newItem] = newShoppingItem
        }
        myTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func cancelShoppingItem() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myShoppingList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let myShoppingDetail = "จำนวน \(myShoppingList[indexPath.row].shoppingProductNumber) @\(myShoppingList[indexPath.row].shoppingProductUnitPrice) บาท"
        cell.textLabel?.text = myShoppingList[indexPath.row].shoppingProductName
        cell.detailTextLabel?.text = myShoppingDetail
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Data of that row from Array **** if database exist need to remove from database also.
            myShoppingList.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
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


    
    // MARK: Allow cell editable
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempShoppingItem = myShoppingList[sourceIndexPath.row]
        myShoppingList.remove(at: sourceIndexPath.row)
        myShoppingList.insert(tempShoppingItem, at:destinationIndexPath.row)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        (segue.destination as! ShoppingItemViewController).delegate = self
        let myVC = segue.destination as! ShoppingItemViewController
        if segue.identifier == "NewItem" {
            myVC.myNewItem = -1
        }else {
            let indexPath = myTableView.indexPathForSelectedRow!
            myVC.myShoppingItem = myShoppingList[indexPath.row]
            myVC.myNewItem = indexPath.row
        }
        myVC.delegate = self
    }
}

