//
//  Place.swift
//  MyCoreLocationApp
//
//  Created by DrKeng on 10/9/2560 BE.
//  Copyright © 2560 ANT. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    var title : String?
    var subtitle: String?
    var coordinate : CLLocationCoordinate2D
    
    init(title : String, subtitle : String, coordinate : CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
