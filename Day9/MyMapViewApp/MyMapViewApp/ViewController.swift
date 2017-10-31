//
//  ViewController.swift
//  MyMapViewApp
//
//  Created by Amnuay M on 10/9/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //Specify Self as Delegate to MapKitView
        myMapView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        let myLocation1 = MyAnnotation()
        myLocation1.coordinate = CLLocationCoordinate2DMake(13.7455368, 100.533418)
        myLocation1.title = "True Incube Space"
        myLocation1.subtitle = "ปทุมวัน"
        myLocation1.image = #imageLiteral(resourceName: "true")
//        myLocation1.
        
        let myLocation2 = MyAnnotation()
        myLocation2.coordinate = CLLocationCoordinate2DMake(13.7443, 100.5444)
        myLocation2.title = "ห้างสรรพสินค้าเซ็นทรัล"
        myLocation2.subtitle = "ชิดลม"
        myLocation2.image = UIImage(named: "cen.png")
        
        let myLocation3 = MyAnnotation()
        myLocation3.coordinate = CLLocationCoordinate2DMake(13.72848, 100.53506)
        myLocation3.title = "เซ็นทรัลสีลมคอมเพล็กซ์"
        myLocation3.subtitle = "ถนนสีลม"
        myLocation3.image = UIImage(named: "cen.png")
        
        let myLocation4 = MyAnnotation()
        myLocation4.coordinate = CLLocationCoordinate2DMake(13.7236035, 100.5291469)
        myLocation4.title = "สถานี BTS ช่องนนทรี"
        myLocation4.subtitle = "ถนนนราธิวาสราชนครินทร์"
        myLocation4.image = UIImage(named: "bts.png")
        
        var myLocationAnnotationSet : [MyAnnotation] = []
        myLocationAnnotationSet.append(myLocation1)
        myLocationAnnotationSet.append(myLocation2)
        myLocationAnnotationSet.append(myLocation3)
        myLocationAnnotationSet.append(myLocation4)
        myMapView.showAnnotations(myLocationAnnotationSet, animated: true)
        myMapView.selectAnnotation(myLocation1, animated: true)
        
        //Define MKPlaceMark for start and destination PlaceMark
        let startPlaceMark = MKPlacemark(coordinate: myLocation4.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: myLocation1.coordinate)
        
        //Define MKMapItem Object for routing
        let startMapItem = MKMapItem(placemark: startPlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        //Create MKDirectionRequest
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = startMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        //Calculate Direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard response != nil else{
            if error != nil {
                print("Error : \(error!)")
            }
            return
        }
        //Draw Directions on the map
        print("Total routes is \(String(describing: response?.routes.count))")
        let route = response?.routes[0]
            self.myMapView.add((route?.polyline)!, level: .aboveRoads)
//        self.myMapView.add((route?.polyline)!, level: .aboveRoads)
        
        //Specify display size according to route on map with edge padding
        let showingRect = route?.polyline.boundingMapRect
        self.myMapView.setVisibleMapRect(showingRect!, edgePadding: UIEdgeInsetsMake(45.0, 45.0, 45.0, 45.0), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Specify id for MKAnnotationView
        let identifier = "MyPin"
        
        //repeat call
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53 ))
        let v = annotation as! MyAnnotation
        leftIconView.image = v.image
        annotationView!.leftCalloutAccessoryView = leftIconView
        
        let calloutButton = UIButton(type: .detailDisclosure)
        annotationView!.rightCalloutAccessoryView = calloutButton
        
        return annotationView
        }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "detailSegue", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let v = sender as! MKPinAnnotationView
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.myLocationName = (v.annotation!.title!)!
        destinationVC.myLocationStreet = (v.annotation!.subtitle!)!
        destinationVC.myLocationCoordinate = (v.annotation?.coordinate)!
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

