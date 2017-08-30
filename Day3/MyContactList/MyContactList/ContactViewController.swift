//
//  ContactViewController.swift
//  MyContactList
//
//  Created by Amnuay M on 8/28/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let contactType = ["ครอบครัว", "เพื่อนสมัยเรียน", "เพื่อนร่วมงาน", "ลูกค้าและสถานประกอบการ"]
    let publicType = ["ส่วนตัว", "ที่ทำงาน"]
    var myContactInfo : ContactInformation = ContactInformation()
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtNickName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var pickerViewContactType: UIPickerView!
    
    @IBAction func saveContactInfoMethod() {
        let myContactType = contactType[pickerViewContactType.selectedRow(inComponent: 0)]
        let myPublicType = publicType[pickerViewContactType.selectedRow(inComponent: 1)]
        print("Contact Saved Successfully!!!!")
        print("ชื่อ-นามสกุล : \(txtName.text!)")
        print("ชื่อเล่น : \(txtNickName.text!)")
        print("เบอร์โทร : \(txtPhoneNumber.text!)")
        print("ประเภท Contact : \(myContactType)-\(myPublicType)")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        print("NumberOfComponent")
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        print("NumberOfRows")
        if component == 0 {
            return contactType.count
        } else {
            return publicType.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print("LoadTitle")
        if component == 0 {
            return contactType[row]
        }else {
            return publicType[row]
        }
    }
    
    @IBAction func ResetScreen() {
        txtName.text = ""
        txtNickName.text = ""
        txtPhoneNumber.text = ""
        pickerViewContactType.selectRow(2, inComponent: 0, animated: true)
        pickerViewContactType.selectRow(1, inComponent: 1, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //resigned first responder
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = myContactInfo.contactNickName
        self.txtName.text = myContactInfo.contactName
        self.txtNickName.text = myContactInfo.contactNickName
        self.txtPhoneNumber.text = myContactInfo.contactPhoneNumber
        self.pickerViewContactType.selectRow(myContactInfo.contactType, inComponent: 0, animated: true)
        self.pickerViewContactType.selectRow(myContactInfo.contactPublicType, inComponent: 1, animated: true)
        
        // Do any additional setup after loading the view, typically from a nib.
//        pickerViewContactType.selectedRow(inComponent: <#T##Int#>)
//        pickerViewContactType.selectRow(2, inComponent: 0, animated: true)
//        pickerViewContactType.selectRow(1, inComponent: 1, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

