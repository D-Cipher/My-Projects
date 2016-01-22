//
//  ViewController.swift
//  Where Is My Car
//
//  Created by Tingbo Chen on 1/14/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var places_dict = [Dictionary<String,String>()]

/*
To Set Up User location:
-Build Phases > Link Binary With Libraries > + > CoreLocation.framework
-In "Info.plist" add:
-NSLocationWhenInUseUsageDescription  Type: String, Value: Would you like to share your location?
-NSLocationAlwaysUsageDescription  Type: String, Value: Are you allowing app to access your location?
*/

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate{

    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        self.mapView.showsUserLocation = true
        
        //Allowing User to add Annotation
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.5
        self.mapView.addGestureRecognizer(uilpgr)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    //Functions allow User to drag annotation:
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.draggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.Ending {
            let droppedAt = view.annotation?.coordinate
            
            print(droppedAt!.latitude)
            print(droppedAt!.longitude)
        }
    }

    */
    
    //Function for Updating User location to center on User:
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        /*
        //Adds an Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location!.coordinate
        annotation.title = "New Place"
        annotation.subtitle = "One day I'll own here..."
        self.mapView.addAnnotation(annotation)
        */
        
        //Stops updating
        self.locationManager.stopUpdatingLocation()
        
        //print(annotation.coordinate)
    }
    
    //Function for User to Add Annotation
    func action(gestureRecognizer:UIGestureRecognizer) {
        //print("gesture recognized") //for testing
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        let newCoordinate: CLLocationCoordinate2D = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        //Reverse Geocoder to get the address:
        let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            var title = ""
            
            if(error == nil) {
                if let p = placemarks?[0] {
                    var subThoroughfare: String = ""
                    var thoroughfare: String = ""
                    
                    if p.subThoroughfare != nil {
                        subThoroughfare = p.subThoroughfare!
                    }
                    if p.thoroughfare != nil {
                        thoroughfare = p.thoroughfare!
                    }
                    
                    title = "\(subThoroughfare) \(thoroughfare)"
                }
            }
            if title == "" {
                title = "Added \(NSDate())"
            
            }
            
            places_dict.append(["name":title,"lat":"\(newCoordinate.latitude)","long":"\(newCoordinate.longitude)"])
            
            //Adds Annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            annotation.title = title
            //annotation.subtitle = "One day I'll own here..."
            self.mapView.addAnnotation(annotation)
            print(title)
        }
    }
}
