//
//  AddStudentViewController.swift
//  RateMyStudentDB
//
//  Created by Amnuay M on 9/11/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class AddStudentViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var myImageController : UIImagePickerController?
    var isNewImage = false
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtStudent: UITextField!
    @IBOutlet weak var txtScore: UITextField!
    
    @IBAction func ImageTouch() {
        let methodSelectController = UIAlertController(title: "RateMyStudentDB", message: "Select Image source", preferredStyle: .actionSheet)
        let CameraSourceButton = UIAlertAction(title: "Camera", style: .default, handler: {
            (action) in self.cameraButtonMethod()})
        let CameraRollButton = UIAlertAction(title: "CameraRoll", style: .default, handler: {(action) in self.selectImgMethod()})
        let CancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        methodSelectController.addAction(CameraSourceButton)
        methodSelectController.addAction(CameraRollButton)
        methodSelectController.addAction(CancelButton)
        
        self.present(methodSelectController, animated: true, completion: nil)
    }
    
    
    @IBAction func saveMethod(){
        //สร้าง Object ของ AppDelegate เพื่อเรียกใช้ persistentContainer
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = myAppDelegate.persistentContainer.viewContext
        let newStudent = NSEntityDescription.insertNewObject(forEntityName: "StudentTB", into: myContext)
        
        let trimStudentName = txtStudent.text?.trimmingCharacters(in: .whitespaces)
        let trimStudentScore = txtScore.text?.trimmingCharacters(in: .whitespaces)

//
        //HomeWork solution
//        let checkStudentName = (txtStudent.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
//
//        if let v = Int(txtScore.text!) {
//            if (checkStudentName != true) && (imgView.image != nil) {
//                //Create Object from AppDelegate to enable persistentContainer
//                let my AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                let myContext = myAppDelegate.persistentContainer.viewContext
//
//            }
//        }
        
        
        // .isEmpty require unwrap ! below is forced unwrap not invert boolean
        if ((trimStudentScore?.characters.isEmpty)! || (trimStudentName?.characters.isEmpty)! || (self.imgView.image == nil)){

            let alertController = UIAlertController(title: "RateMyStudentDB", message: "ข้อมูลไม่ครบถ้วน", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            let okButton = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in myContext.delete()})
//            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in myContext.delete()})
            
            alertController.addAction(okButton)
//            alertController.addAction(cancelButton)
            
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            newStudent.setValue(Int(txtScore.text!)!, forKey: "studentRatingScore")
            newStudent.setValue(txtStudent.text!, forKey: "studentName")
            let theImageData = UIImagePNGRepresentation(imgView.image!)! as NSData
            newStudent.setValue(theImageData, forKey: "studentImage")
            
            //บันทึกลงฐานข้อมูล
            do{
                try myContext.save()
                print("บันทึกข้อมูลแล้ว!")
            }catch{
                print("ไม่สามารถบันทึกข้อมูลได้")
            }
        }
        
//        newStudent.setValue(txtStudent.text!, forKey: "studentName")
//        newStudent.setValue(Int(txtScore.text!)!, forKey: "studentRatingScore")

        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelMethod(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: Camera Method
    @IBAction func cameraButtonMethod(){
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
    
    // MARK: - Select Image from Camera Roll
    @IBAction func selectImgMethod(){
        myImageController = UIImagePickerController()
        if let theController = myImageController{
            theController.sourceType = .savedPhotosAlbum
            theController.mediaTypes = [String(kUTTypeImage)]
            theController.allowsEditing = true
            theController.delegate = self
//            present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
            present(theController, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //ปิด Album Controller
        picker.dismiss(animated: true, completion: nil)
        
        //นำรูปที่เลือกไปแสดงใน ImageView
        let theImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imgView.image = theImage
        
        if isNewImage {
            UIImageWriteToSavedPhotosAlbum(theImage, self, nil, nil)
            isNewImage = false
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
