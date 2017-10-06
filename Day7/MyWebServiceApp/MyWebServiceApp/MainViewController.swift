//
//  MainViewController.swift
//  MyWebServiceApp
//
//  Created by DrKeng on 9/23/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var moveAlready = false
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    func parseJSON(myData : Data){
        let json = try! JSONSerialization.jsonObject(with: myData, options: .mutableContainers)

//        do{
//            let json = try JSONSerialization.jsonObject(with: myData, options: .mutableContainers)
//        } catch let error as NSError {
//            print(error.description)
//            return()
//        }
//
//        do {
//            try <#throwing expression#>
//        } catch <#pattern#> {
//            <#statements#>
//        }
        
        let loginResults = json as! [[String : String]]

        var myResult : String = ""
        
        if loginResults.count > 0 {
            myResult = loginResults.first!["myResult"]!
            if myResult == "OK" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MediaListTBV") as! MediaListTableViewController
                
                let navigationController = UINavigationController(rootViewController: vc)
                self.present(navigationController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "An error occurred", message: "Username or Password not correct", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func loginMethod() {
        self.saveUserName()
        
        //HTTP Request initialization
        let myURL : URL = URL(string: "http://www.worasit.com/iosbuilder/login.php")!
        var myRequest : URLRequest = URLRequest(url: myURL)
        let mySession = URLSession.shared
        myRequest.httpMethod = "POST"
        
        //Initialize parameter
        let params = ["username":"\(txtUserName.text!)", "password":"\(txtPassword.text!)"] as Dictionary<String, String>
        myRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        myRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        myRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let myTask = mySession.dataTask(with: myRequest){(responseData, responseStatus, error) in
            
            //Force Operation into Main Queue -> So that it waits for return
            OperationQueue.main.addOperation {
                print("responseStatus = \(responseStatus!)")
                print("responseData = \(responseData!)")
                self.parseJSON(myData: responseData!)
            }
        }
        myTask.resume()
    }
    
    func adjustingHeight(_ show:Bool, notification:NSNotification){
        var userInfo = notification.userInfo!
        
        //read Keyboard size
//        let keyboardFrame:CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size

        let keyboardBounds:CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        //Change Sign In Button location
        if (show && !moveAlready){
//            bottomConstraint.constant += keyboardFrame.height
            bottomConstraint.constant += keyboardBounds.height
            moveAlready = true
        }
        if (!show && moveAlready){
//            bottomConstraint.constant -= keyboardFrame.height
            bottomConstraint.constant -= keyboardBounds.height
            moveAlready = false
        }
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(true, notification: notification)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveUserName(){
        let defaults : UserDefaults = UserDefaults.standard
        defaults.set(txtUserName.text!, forKey: "myUserName")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Read data from Detaults and put it in TextField
        let defaults = UserDefaults.standard
        txtUserName.text = defaults.string(forKey: "myUserName")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

