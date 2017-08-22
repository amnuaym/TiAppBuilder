//
//  BMICalculatorViewController.swift
//  BMICalculator
//
//  Created by Amnuay M on 8/21/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class BMICalculatorViewController: UIViewController {

    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtViewResult: UITextView!
    
    @IBAction func clearContentMethod(_ sender: Any) {
        txtWeight.text = ""
        txtHeight.text = ""
        txtViewResult.text = ""
    }
    
    func bmiResultInterpretation(bmiValue : Double) -> String{
        var result : String = "ค่า BMI = \(bmiValue) \n"
        if bmiValue >= 40.0 {
            result += "คุณเป็นโรคอ้วนขั้นสูงสุด กรุณาพบแพทย์ด่วน"
        }else if bmiValue >= 35.0 {
            result += "คุณเป็นโรคอ้วนระดับ 2 คุณเสี่ยงต่อการเกิดโรคที่มากับความอ้วน หากคุณมีเส้นรอบเอวมากกว่าเกณฑ์ปกติคุณจะเสี่ยงต่อการเกิดโรคสูง คุณต้องควบคุมอาหาร และออกกําลังกายอย่างจริงจัง"
        }else if bmiValue >= 28.5 {
            result += "คุณเป็นโรคอ้วนระดับ 1 และหากคุณมีเส้นรอบเอวมากกว่า 90 ซม.(ชาย) 80 ซม.(หญิง) คุณจะมีโอกาสเกิดโรคความดัน เบาหวานสูง จําเป็นต้องควบคุมอาหาร และออกกำลังกายอย่างจริงจัง"
        }else if bmiValue >= 23.5 {
            result += "น้ําหนักเกิน หากคุณมีกรรมพันธ์เป็นโรคเบาหวานหรือไขมันในเลือดสูงต้องพยายามลดน้ําหนักให้ดัชนีมวลกายต่ํากว่า 23"
        }else if bmiValue >= 18.5 {
            result += "น้ําหนักปกติ และมีปริมาณไขมันอยู่ในเกณฑ์ปกติมักจะไม่ค่อยมีโรคร้าย อุบัติการณ์ของโรคเบาหวาน ความดันโลหิตสูงต่ํากว่าผู้ที่อ้วนกว่านี้"
        }else {
            result += "น้ําหนักน้อยเกินไป ซึ่งอาจจะเกิดจากนักกีฬาที่ออกกําลังกายมาก และได้รับสารอาหารไม่เพียงพอ วิธีแก้ไขต้องรับประทานอาหารที่มีคุณภาพ และมีปริมาณพลังงานเพียงพอ และออกกําลังกายอย่างเหมาะสม"
        }
        return result
    }
    
    @IBAction func bmiCalculationMethod(_sender: Any) {
//        let myWeight = Double(txtWeight.text!)!
//        let myHeight = Double(txtHeight.text!)!/100.0
//        let myBMIResult = myWeight / (myHeight * myHeight)
        
        var myWeight : Double
        var myHeight : Double
        var myBMIResult : Double
        txtViewResult.text! = ""
        
        if (txtWeight.text!.characters.count == 0) || (txtHeight.text!.characters.count == 0 ) {
//        if txtWeight.text == nil{   -> ใช้ไม่ได้ เนื่องจาก ค่าของ text String ไม่เป็น Null
            if (txtWeight.text!.characters.count == 0) {txtViewResult.text! += "ท่านยังไม่ได้ใส่น้ำหนัก\n"}
            if (txtHeight.text!.characters.count == 0) {txtViewResult.text! += "ท่านยังไม่ได้ใส่ส่วนสูง\n"}
        }else {
            myWeight = Double(txtWeight.text!)!
            myHeight = Double(txtHeight.text!)!/100.0
            myBMIResult = myWeight / (myHeight * myHeight)
            txtViewResult.text = bmiResultInterpretation(bmiValue: myBMIResult)
        }
        txtWeight.resignFirstResponder()
        txtHeight.resignFirstResponder()
        txtViewResult.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
