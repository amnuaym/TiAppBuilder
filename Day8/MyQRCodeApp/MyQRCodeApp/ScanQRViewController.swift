//
//  ScanQRViewController.swift
//  MyQRCodeApp
//
//  Created by Amnuay M on 10/2/17.
//  Copyright © 2017 ANT. All rights reserved.
//

import UIKit
import AVKit

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBAction func backMethod() {
        navigationController?.popToRootViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblResult: UILabel!
    
    //ประกาศตัวแปรเพื่อใช้สําหรับการตรวจจับ QRCode
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //สร้างตัวแปรแทน AVCaptureDevice และทําการ Initialized
        let captureDevice = AVCaptureDevice.default(for:
            AVMediaType.video)
        //สร้างตัวแปรแทน AVCaptureDeviceInput
        var inputDevice : AVCaptureDeviceInput?
        do{
            inputDevice = try AVCaptureDeviceInput(device: captureDevice!)
            }catch let error as NSError {
            print(error.description)
            return
            }
    
        //เริ่ม Session การอ่าน QRCode
        captureSession = AVCaptureSession()
        //กําหนด InputDevice ให้กับ captureSession
        captureSession?.addInput(inputDevice!)
        //สร้างตัวแปรแทน AVCaptureMetadataOutput
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    
        //สร้าง Video Preview Layer และนําไปใส่ไว้ที่ View หลัก
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        //ย้าย headerView และ lblResult มาไว้ด้านหน้า
        view.bringSubview(toFront: headerView)
        view.bringSubview(toFront: lblResult)
        
        //ใส่ Frame เพื่อ hightlight ระหว่าง Scan QRCode
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)

        //เริ่ม Capture QRCode
        captureSession?.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        //ตรวจสอบว่าพบ QRCode หรือไม่ โดยดูที่ metadataObjects
        if metadataObjects.count == 0{
            qrCodeFrameView?.frame = CGRect.zero
            lblResult.text = "No QR Code present!"
        }else{
            //อ่านค่า MetaDataObjects ที่ได้มา
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            //ตรวจสอบว่าเป็น QR Code หรือไม่
            if metadataObj.type == AVMetadataObject.ObjectType.qr{
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView?.frame = (barCodeObject?.bounds)!
                if metadataObj.stringValue != nil {
                    lblResult.text = metadataObj.stringValue
                    captureSession?.stopRunning()
                }
            }
        }
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
