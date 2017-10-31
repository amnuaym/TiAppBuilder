//
//  DetailViewController.swift
//  MyMapViewApp
//
//  Created by Amnuay M on 10/9/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    var myLocationName : String = ""
    var myLocationStreet : String = ""
    var myLocationCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var locationStreet: UILabel!
    @IBOutlet weak var locationLat: UILabel!
    @IBOutlet weak var locationLong: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = myLocationName
        // Do any additional setup after loading the view.
        locationName.text = myLocationName
        locationStreet.text = myLocationStreet
        locationLat.text = "\(myLocationCoordinate.latitude)"
        locationLong.text = "\(myLocationCoordinate.longitude)"
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
