//
//  ViewController.swift
//  MyLocalizedApp
//
//  Created by DrKeng on 10/4/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!

    let alertTitle : String = NSLocalizedString("DPU", comment: "")
    let alertMessage : String = NSLocalizedString("Thank you for your comments and suggestions", comment: "")
    let cancelButtonTitle : String = NSLocalizedString("Cancel", comment: "")
    let okButtonTitle : String = NSLocalizedString("OK", comment: "")
    
    @IBAction func submitMethod() {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: okButtonTitle, style: .default, handler: nil)
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        present(alertController, animated: true, completion:  nil)
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

