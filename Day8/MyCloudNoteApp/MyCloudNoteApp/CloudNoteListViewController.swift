//
//  CloudNoteListViewController.swift
//  MyCloudNoteApp
//
//  Created by DrKeng on 9/30/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import CloudKit

class CloudNoteListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //AM: Array to collect data loaded from Cloud
    var notesList : [CKRecord]? = []
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    func fetchNotesListFromiCloud(){
        //AM: Create Variable named Container and specify Database
        let container = CKContainer.default()
        let privateDatabase = container.privateCloudDatabase
//        let publicDatabase = container.publicCloudDatabase
//        let sharedDatabase = container.sharedCloudDatabase

        let myPredicate = NSPredicate(value: true)
        
        //AM: Create Query variable
        let myQuery = CKQuery(recordType: "MyNotes", predicate: myPredicate)
        privateDatabase.perform(myQuery, inZoneWith: nil) { (results, error) in
            if error != nil{
                print(error!)
            }else{
                print(results!)
                OperationQueue.main.addOperation {
                    self.notesList!.removeAll()
                    for result in results!{
                        self.notesList?.append(result)
                    }
                    self.myTableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "My iCloud Note"
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchNotesListFromiCloud()
    }
    
    // MARK: - Table view data source
    
 func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesList!.count
    }
    
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let noteRecord : CKRecord = notesList![indexPath.row]
    
        // Configure the cell...
    //Date and time for note last save
    let dateFormatter : DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm:ss"
    let postedDate = dateFormatter.string(from: (noteRecord.value(forKey: "noteEditedDate") as! Date))
    cell.textLabel?.text = noteRecord.value(forKey: "noteTitle") as? String
    cell.detailTextLabel?.text = "Posted at \(postedDate)"
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //AM: create variable to point to RecordID we want to delete
            let deleteRecordID = notesList![indexPath.row].recordID
            
            //AM: Create variable to specify Container and Database we want to delete
            let container = CKContainer.default()
            let privateDatabase = container.privateCloudDatabase

            privateDatabase.delete(withRecordID: deleteRecordID, completionHandler: { (recordID, error) in
                if error != nil{
                    print(error!)
                }else{
                    OperationQueue.main.addOperation {
                        self.notesList!.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .right)
                    }
                }
            })
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

    //MARK: Prepare for Segue
        //In a storyboard based application, you will often need to do a little preparation before navigation
//    override func prepareForInterfaceBuilder() {
//        <#code#>
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNoteSqgue"{
            let indexPath = myTableView.indexPathForSelectedRow!
            let myVC = segue.destination as! AddNewNoteViewController
            myVC.editedNoteRecord = notesList![indexPath.row]
        }
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

