//
//  MainTableViewTableViewController.swift
//  MyContactList
//
//  Created by Amnuay M on 8/28/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class MainTableViewTableViewController: UITableViewController {

    var myContactInfoList : [ContactInformation] = []
    override var prefersStatusBarHidden: Bool {return true}
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //กำหนดข้อความไว้ในส่วนของ Navigation
        self.title = "My Contact List"
        
        //เตรียมข้อมูล ContactInformation
        let myFriend1 : ContactInformation =
            ContactInformation(contactName: "วรสิทธิ์ ชูชัยวัฒนา", contactNickName: "เก่ง", contactPhoneNumber: "095-999-9999", contactType: 0, contactPublicType: 0, contactImage: UIImage(named: "b1.png")!)
        let myFriend2 : ContactInformation =
            ContactInformation(contactName: "เอมมี่ ศรีประเสริฐ", contactNickName: "เอม", contactPhoneNumber: "095-123-4567", contactType: 1, contactPublicType: 0, contactImage: UIImage(named: "g1.png")!)
        let myFriend3 : ContactInformation =
            ContactInformation(contactName: "มาลินี สุขใจ", contactNickName: "มะลิ", contactPhoneNumber: "02-123-4567", contactType: 2, contactPublicType: 1, contactImage: UIImage(named: "g2.png")!)
        let myFriend4 : ContactInformation =
            ContactInformation(contactName: "กิตติ คนดี" , contactNickName: "กิต", contactPhoneNumber: "081-987-6543", contactType: 3, contactPublicType: 1, contactImage: UIImage(named: "b2.png")!)
        
        myContactInfoList.append(myFriend1)
        myContactInfoList.append(myFriend2)
        myContactInfoList.append(myFriend3)
        myContactInfoList.append(myFriend4)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        return myContactInfoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.imageView?.image = myContactInfoList[indexPath.row].contactImage
        cell.textLabel?.text = "\(myContactInfoList[indexPath.row].contactName) (\(myContactInfoList[indexPath.row].contactNickName))"
        cell.detailTextLabel?.text = myContactInfoList[indexPath.row].contactPhoneNumber

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Data of that row from Array **** if database exist need to remove from database also.
            myContactInfoList.remove(at: indexPath.row)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "UpdateItem" {
        
        let indexPath = self.tableView.indexPathForSelectedRow!
        let detailVC = segue.destination as! ContactViewController
        detailVC.myContactInfo = myContactInfoList[indexPath.row]
        }
        
    }

}
