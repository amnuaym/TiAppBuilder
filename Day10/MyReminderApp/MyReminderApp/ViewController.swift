//
//  ViewController.swift
//  MyReminderApp
//
//  Created by DrKeng on 10/15/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBAction func addNotificationMethod() {
        let selectedDate = myDatePicker.date
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        myAppDelegate.scheduleNotification(myDate: selectedDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

