//
//  QRCodeViewController.swift
//  MyQRCodeApp
//
//  Created by DrKeng on 9/25/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var myButton: UIButton!
    
    var qrCodeImage : CIImage?
    
    @IBAction func qrCodeGenerateMethod() {
        if qrCodeImage == nil {
            if !(txtContent.text?.isEmpty)!{
                //Convert Text into Data
                let data = txtContent.text?.data(using: .utf8)
                
                //Create Filter from CoreImage as CIQrCodeGenerator
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "inputMessage")

                //L, M, Q, H => Error Resilience value -> inputCorrectionLEvel
                filter?.setValue("Q", forKey: "inputCorrectionLevel")
                
                qrCodeImage = filter?.outputImage
   
                //Adjust QR Code image size by its Scale
                let scaleX = imgQRCode.frame.size.width / (qrCodeImage?.extent.size.width)!
                let scaleY = imgQRCode.frame.size.height / (qrCodeImage?.extent.size.height)!
                let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                let adjustedQRCodeImage = qrCodeImage?.transformed(by: transform)
                
                imgQRCode.image = UIImage(ciImage: adjustedQRCodeImage!)
 
//                // if not scale image
//                imgQRCode.image = UIImage(ciImage: qrCodeImage!)
                txtContent.resignFirstResponder()
                myButton.setTitle("Clear QR Code", for: .normal)
            }
        }else{
            imgQRCode.image = nil
            qrCodeImage = nil
            txtContent.text = ""
            myButton.setTitle("Generate QR Code", for: .normal)
        }
    
    
    
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

