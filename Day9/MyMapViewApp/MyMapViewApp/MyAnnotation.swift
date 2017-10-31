//
//  MyAnnotation.swift
//  MyMapViewApp
//
//  Created by Amnuay M on 10/9/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image : UIImage?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = ""
        self.subtitle = ""
        self.image = UIImage()
    }

}
