//
//  ViewController.swift
//  MyCameraApp
//
//  Created by Amnuay M on 9/4/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var myImageController : UIImagePickerController?
    var isNewImage = false
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBAction func cameraMethod() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            myImageController = UIImagePickerController()
            if let theController = myImageController{
                theController.sourceType = .camera
                theController.mediaTypes = [String(kUTTypeImage)]
                theController.allowsEditing = true
                theController.delegate = self
                present(theController, animated: true, completion: nil)
                isNewImage = true
            }else{
                let alertController = UIAlertController(title: "MyCameraApp", message: "Cannot access Camera", preferredStyle: .alert)
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelButton)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func cameraRollMethod() {
        myImageController = UIImagePickerController()
        if let theController = myImageController{
            theController.sourceType = .savedPhotosAlbum
            theController.mediaTypes = [String(kUTTypeImage)]
            theController.allowsEditing = true
            theController.delegate = self
            present(theController, animated: true, completion: nil )
            isNewImage = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //#1 ปิด camera/album controller
        picker.dismiss(animated: true, completion: nil)

        //#2 นํารูปที่ถ่าย/เลือกไปแสดงใน ImageView
        //ถ้า AllowEditing เป็น False ใช้ UIImagePickerControllerOriginalImage

        let theImage = info[UIImagePickerControllerEditedImage] as! UIImage
            myImageView.image = theImage
    
        //#3 ถ้าถ่ายรูปใหม่ ก็ทําการเก็บไว้ใน Camera Roll
        if isNewImage {
        UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil)
        isNewImage = false
        }
        btnShare.isHidden = false
    }
    
    @IBAction func postMethod() {
        let activityItems : [AnyObject]? = [myImageView.image!]
        let activityController = UIActivityViewController(activityItems: activityItems!, applicationActivities: nil)
        
//        activityController.excludedActivityTypes = [UIActivityType.mail, UIActivityType.copyToPasteboard]
        activityController.excludedActivityTypes = [UIActivityType.mail, UIActivityType.copyToPasteboard]
        self.present(activityController, animated: true, completion: nil)

        
        activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in var resultMessage = ""
            if completed {
                if error == nil {
                    self.myImageView.image = nil
                    resultMessage = "Successful!"
                    self.btnShare.isHidden = true
                }else{
                    resultMessage = "Error : \(error!)"
                    self.btnShare.isHidden = true
                }
                let alertController = UIAlertController(title: "Result", message: resultMessage, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "MyCameraApp"
        btnShare.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

