//
//  ShoppingItemViewController.swift
//  MyShoppingList
//
//  Created by Amnuay M on 9/4/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

protocol ShoppingItemViewControllerDelegate {
    func addShoppingItem(newShoppingItem : ShoppingItem, newItem : Int)
    func cancelShoppingItem()
}

class ShoppingItemViewController: UIViewController {
    var delegate : ShoppingItemViewControllerDelegate?
    var myShoppingItem : ShoppingItem?
    var myNewItem : Int = 0
    
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductNumber: UITextField!
    @IBOutlet weak var txtProductUnitPrice: UITextField!
    
    @IBAction func saveMethod() {
//        let myShoppingItem : ShoppingItem = ShoppingItem()
        if myShoppingItem == nil {
            myShoppingItem = ShoppingItem()
        }
        
        
        //Hide Keyboard
        //self.view.endEditing(<#T##force: Bool##Bool#>)
        //for any action
        //resignFirstResponder() when leave text field.
        
        self.view.endEditing(true)
        txtProductName.resignFirstResponder()
        txtProductNumber.resignFirstResponder()
        txtProductUnitPrice.resignFirstResponder()
        
//        //อ่านค่าจาก TextField
//        myShoppingItem?.shoppingProductName = txtProductName.text!
//        myShoppingItem?.shoppingProductNumber = Int(txtProductNumber.text!)!
//        myShoppingItem?.shoppingProductUnitPrice = Double(txtProductUnitPrice.text!)!
        
        let trimProductName = txtProductName.text?.trimmingCharacters(in: .whitespaces)
        let trimProductNumber = txtProductNumber.text?.trimmingCharacters(in: .whitespaces)
        let trimProductUnitPrice = txtProductUnitPrice.text?.trimmingCharacters(in: .whitespaces)
        
        if ((trimProductName?.characters.isEmpty)! || (trimProductNumber?.characters.isEmpty)! || (trimProductUnitPrice?.characters.isEmpty)!) {

            
            //  สร้าง AlertController Object
            // .actionSheet -> Alert from bottom up with action button
            let alertController = UIAlertController(title: "MyShoppingList", message: "กรุณากรอกข้อมูล Shopping Item ให้ครบถ้วน", preferredStyle: .alert)

            // สร้าง Button (Action) สำหรับ AlertController
            // ActionButton style .destructive -> Red text
            let cancelButton = UIAlertAction(title: "ปิดหน้าต่าง", style: .cancel, handler: nil)
            let clearButton = UIAlertAction(title: "เคลียร์ข้อมูล", style: .default, handler: {
                (action) in self.txtProductName.text = ""
                self.txtProductNumber.text = ""
                self.txtProductUnitPrice.text = ""
            })
            
            // เพิ่ม Button ลงไปใน AlertController Object
            alertController.addAction(cancelButton)
            alertController.addAction(clearButton)
            
            self.present(alertController, animated: true, completion: nil)

            // UIAlertController( -> Wait for option that contain preferredStyle:
            //let alertController = UIAlertController(title: "MyShoppingList", message: "กรุณากรอกข้อมูล Shopping Item ให้ครบถ้วน", preferredStyle)    -> Not work. no option for preferredStyle shown.
        }else {
        
                myShoppingItem?.shoppingProductName = trimProductName!
                myShoppingItem?.shoppingProductNumber = Int(trimProductNumber!)!
                myShoppingItem?.shoppingProductUnitPrice = Double(trimProductUnitPrice!)!
            
                //เรียกผู้ช่วยให้มาทำงานให้
                delegate?.addShoppingItem(newShoppingItem: myShoppingItem!, newItem: myNewItem)
            }
    }
    
    
    @IBAction func cancelMethod() {
        self.view.endEditing(true)
        txtProductName.resignFirstResponder()
        txtProductNumber.resignFirstResponder()
        txtProductUnitPrice.resignFirstResponder()
        //เรียกผู้ช่วยมาให้มาทำงานให้
        delegate?.cancelShoppingItem()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let v = myShoppingItem {
            txtProductName.text = v.shoppingProductName
            txtProductNumber.text = "\(v.shoppingProductNumber)"
            txtProductUnitPrice.text = "\(v.shoppingProductUnitPrice)"
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
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
