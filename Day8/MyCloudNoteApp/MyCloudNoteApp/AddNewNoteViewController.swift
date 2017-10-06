//
//  AddNewNoteViewController.swift
//  MyCloudNoteApp
//
//  Created by DrKeng on 9/30/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import CloudKit

class AddNewNoteViewController: UIViewController {
    
    //Create new variable for editing method
    var editedNoteRecord : CKRecord?
    
    @IBOutlet weak var waitView: UIView!
    
    @IBOutlet weak var txtNoteTitle: UITextField!
    
    @IBOutlet weak var txtNoteDesc: UITextView!
    
    @IBAction func saveMethod(_ sender: Any) {
        //AM: First Trim character
        let myNoteTitle = (txtNoteTitle.text)!.trimmingCharacters(in: .whitespaces)
        let myNoteDesc = (txtNoteDesc.text)!.trimmingCharacters(in: .whitespaces)
        
        if (!myNoteTitle.characters.isEmpty && !myNoteDesc.characters.isEmpty){
            //AM: Show webView for waiting
            waitView.isHidden = false
            
            var noteRecord : CKRecord!
            
            if editedNoteRecord != nil{
                noteRecord = editedNoteRecord
            }else{

                //AM:Prepare data for Key value
                let myTimeStamp = String(format:"%f",NSDate.timeIntervalSinceReferenceDate)
                let timeStampParts = myTimeStamp.components(separatedBy: ".")
                let noteID = CKRecordID(recordName: timeStampParts[0])
                
                
                //AM: Create Object to store Data
                noteRecord = CKRecord(recordType: "MyNotes", recordID: noteID)
                noteRecord.setObject(myNoteTitle as CKRecordValue, forKey: "noteTitle")
                noteRecord.setObject(myNoteDesc as CKRecordValue, forKey: "noteDesc")
                noteRecord.setObject(NSDate(), forKey: "noteEditedDate")
            }
            //AM: Create Variable for Container and Specify Database
            let container = CKContainer.default()
            let privateDatabase = container.privateCloudDatabase
            privateDatabase.save(noteRecord, completionHandler: {(myRecord, error) -> Void in
                if error != nil{
                    print(error!.localizedDescription)
                }
                OperationQueue.main.addOperation { () -> Void in
                    //AM: Hide waitView
                    self.waitView.isHidden = true
                    
                    //AM: to prevent list view not yet update info from iCloud we add AlertController to delay 2-3 sec and let data ready to load
                    let alertController = UIAlertController(title: "MyCloudNote", message: "Data saved on cloud", preferredStyle: .actionSheet)
                    let goBackButton = UIAlertAction(title: "Back to Home Screen", style: .cancel, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    let newNoteButton = UIAlertAction(title: "Create New Note", style: .default, handler: { (action) in
                        self.txtNoteTitle.text = ""
                        self.txtNoteDesc.text = ""
                        //Clear editedNoteRecord to nil
                        self.editedNoteRecord = nil
                    })
                    alertController.addAction(goBackButton)
                    alertController.addAction(newNoteButton)
                    self.present(alertController, animated: true, completion: nil)
                    
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    @IBAction func cancelMethod(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        //In case of so many inbound View use below to return to the root View
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //AM: Hide waitView UIView
        waitView.isHidden = true
        
        if editedNoteRecord != nil{
            txtNoteTitle.text = editedNoteRecord?.value(forKey: "noteTitle") as? String
            txtNoteDesc.text = editedNoteRecord?.value(forKey: "noteDesc") as? String
            self.title = "Edit Note"
        }else{
            self.title = "New Note"
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
