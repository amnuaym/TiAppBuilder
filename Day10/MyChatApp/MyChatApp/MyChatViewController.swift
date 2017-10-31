//
//  MyChatViewController.swift
//  MyChatApp
//
//  Created by DrKeng on 10/12/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import Firebase

class MyChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var messageArray : [Message] = []
    
//    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
//    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBAction func submitMethod() {
        txtMessage.endEditing(true)
        
        //Temporary disable button and textfield to limit error until writing done
        txtMessage.isEnabled = false
        btnSend.isEnabled = false
        
        //Call Firebase Database
        let messageDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : txtMessage.text!]
        
        //Write database with AutoID
        messageDB.childByAutoId().setValue(messageDictionary) { (error, dbReference) in
            if error != nil {
                print(error!)
            }else{
                print("Record success")
            }
            self.txtMessage.text = ""
            self.txtMessage.isEnabled = true
            self.btnSend.isEnabled = true
        }
    }
    
    
    @IBAction func logoutMethod(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error: Sigout error occurred")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        txtMessage.delegate = self
        
        configureTableView()
        
        //Pull Data from Firebase and Observe change in the database
        messageRetrievingMethod()
        
        //When touch on TAbleView then hide the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        chatTableView.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tableViewTapped(){
        txtMessage.endEditing(true)
    }
    
    func configureTableView(){
        //Specify cell hight automatically by message length
        chatTableView.rowHeight = UITableViewAutomaticDimension
        
        //Specify Highest cell row
        chatTableView.estimatedRowHeight = 125.0
        
        //No separation line between cells
        chatTableView.separatorStyle = .none
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

    func messageRetrievingMethod(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded) { (snapshot) in
            let mySnapShotValue = snapshot.value as! Dictionary<String, String>
            let myMessage = mySnapShotValue["MessageBody"]!
            let sender = mySnapShotValue["Sender"]!
            
            //Create Object to store loaded data
            let retrievedMessage = Message()
            retrievedMessage.messageBody = myMessage
            retrievedMessage.sender = sender
            
            //Put retrived data into TableView Array
            self.messageArray.append(retrievedMessage)
            
            //Reconfigure TableView and reload TableView
            self.configureTableView()
            self.chatTableView.reloadData()
            
            //Display the last Row of Chat Screen
            let lastRow = IndexPath(row: self.messageArray.count - 1, section: 0)
            self.chatTableView.scrollToRow(at: lastRow, at: .bottom, animated: true)
            
        }
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageTableViewCell
        
        // Configure the cell...
        cell.myChatMessage.text = messageArray[indexPath.row].messageBody
        cell.myChatSender.text = messageArray[indexPath.row].sender
        
        //Check who send each message
        //to adjust display according to the side of the chat
        //Sender is the same as auth user email
        if cell.myChatSender.text == Auth.auth().currentUser?.email as String!{
            cell.myImage.image = nil
            cell.myChatSender.textAlignment = .right
            cell.myChatMessage.textAlignment = .right
            cell.myChatView.backgroundColor = UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 121.0/255.0, alpha: 1.0)
            
            cell.leftConstraint.constant = 108.0
            cell.rightConstraint.constant = -8
            
        }else{
            //Else that message is from others
            cell.myImage.image = #imageLiteral(resourceName: "avatar")
//            cell.myImage.image = UIImage(named: "avatar")
            cell.myChatSender.textAlignment = .left
            cell.myChatMessage.textAlignment = .left
            cell.myChatView.backgroundColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0)

            cell.leftConstraint.constant = 8.0
            cell.rightConstraint.constant = -108.0

        }
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Data of that row from Array **** if database exist need to remove from database also.
            myContactInfoList.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */
    
    //MARK: - TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            // Adjust heightConstrain of View to accommodate Keyboard
            // Actually should obtain Keyboard bound and calculate
            self.heightContraint.constant = 302 //258+44
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Add Animation to move text field to accommodate keyboard
        UIView.animate(withDuration: 0.3){
            self.heightContraint.constant = 44
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtMessage.endEditing(true)
        return true
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

    
}
