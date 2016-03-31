//
//  MapViewController.swift
//  Where Is My Car
//
//  Created by Tingbo Chen on 1/14/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook

/*
To Set Up User location:
-Build Phases > Link Binary With Libraries > + > CoreLocation.framework
-In "Info.plist" add:
-NSLocationWhenInUseUsageDescription  Type: String, Value: Would you like to share your location?
-NSLocationAlwaysUsageDescription  Type: String, Value: Are you allowing app to access your location?
*/

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate{

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var navigateButtonOutlet: UIBarButtonItem!
    
    @IBOutlet var saveButtonOutlet: UIBarButtonItem!
    
    @IBOutlet var renameButtonOutlet: UIBarButtonItem!
    
    @IBOutlet var statusOutlet: UILabel!
    
    let locationManager = CLLocationManager()
    
    var places_dict = Dictionary<String,String>()
    
    var savedArray: [AnyObject] = []
    
    var bookmarkedArray: [AnyObject] = []
    
    var tempBmArray: [AnyObject] = []
    
    var currPlace_dict = Dictionary<String, AnyObject>()
    
    @IBAction func navigateButtonAction(sender: AnyObject) {
        
        let SpotLocation = CLLocationCoordinate2DMake(currPlace_dict["lat"] as! Double, currPlace_dict["long"] as! Double)
        
        let currentPlacemark = MKPlacemark(coordinate: SpotLocation, addressDictionary: ["current location" : currPlace_dict["title"]!])
        
        print(currentPlacemark)
        
        let mapItem = MKMapItem(placemark: currentPlacemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        if self.places_dict["name"] != nil {
            self.savedArray.insert(self.places_dict, atIndex: 0)
            
            NSUserDefaults.standardUserDefaults().setObject(self.savedArray, forKey: "savedArray")
            
            let temptext = self.places_dict["name"]
            
            self.statusOutlet.text = ("Logged: " + temptext!)
            
            //print(self.savedArray) //for testing
        }
        
        //print(self.places_dict)
        //print(fromSegue_Global)
    }
    
    @IBAction func renameSegueAction(sender: AnyObject) {
        
        self.tempBmArray = [] //for clearing saved object
        
        if self.places_dict["name"] == nil && fromSegue_Global == "recentPlaceSegue" {
            self.tempBmArray.append(self.savedArray[activePlace_GLOBAL])
            
        } else if self.places_dict["name"] == nil && fromSegue_Global == "bmPlaceSegue" {
            self.tempBmArray.append(self.bookmarkedArray[activePlace_GLOBAL])
            
        } else if self.places_dict["name"] != nil {
            self.tempBmArray.append(self.places_dict)
        }
        NSUserDefaults.standardUserDefaults().setObject(self.tempBmArray, forKey: "tempBmArray")
        
        //print(self.tempBmArray) //for testing
        
        //Segue to Rename View Controller
        self.performSegueWithIdentifier("renameSegue", sender: self)
    }
    
    
    
    @IBAction func backButton(sender: AnyObject) {
        if fromSegue_Global == "newPlaceSegue" || fromSegue_Global == "recentPlaceSegue" {
            self.performSegueWithIdentifier("unwindToRecentLocController", sender: self)
            
        } else if fromSegue_Global == "newPlaceSegue2" || fromSegue_Global == "bmPlaceSegue" {
            self.performSegueWithIdentifier("unwindToBookmarkedController", sender: self)
        }
        
    }
    
    func getPermData() {
        //Gets the Saved Data
        if NSUserDefaults().objectForKey("savedArray") != nil {
            self.savedArray = NSUserDefaults().objectForKey("savedArray")! as! NSArray as [AnyObject] //Converting back to Array
        }
        
        //Gets the Bookmarked Data
        if NSUserDefaults().objectForKey("bookmarkedArray") != nil {
            self.bookmarkedArray = NSUserDefaults().objectForKey("bookmarkedArray")! as! NSArray as [AnyObject] //Converting back to Array
        }
        
        //print(self.savedArray) //for testing
        //print(self.bookmarkedArray) //for testing
        
    }
    
    func placeInitialPin() {
        
        if fromSegue_Global == "newPlaceSegue" || fromSegue_Global == "newPlaceSegue2" { //If user is adding a new place
            //print(fromSegue_Global)
            self.saveButtonOutlet.enabled = true
            self.renameButtonOutlet.enabled = true
            
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            
        } else if fromSegue_Global == "recentPlaceSegue" { //If user is looking at a recent place
            
            self.saveButtonOutlet.enabled = false
            self.renameButtonOutlet.enabled = true
            self.mapView.showsUserLocation = true
            
            //Set Current Place
            currPlace_dict["lat"] = NSString(string: String(self.savedArray[activePlace_GLOBAL]["lat"]!!)).doubleValue
            currPlace_dict["long"] = NSString(string: String(self.savedArray[activePlace_GLOBAL]["long"]!!)).doubleValue
            currPlace_dict["title"] = String(self.savedArray[activePlace_GLOBAL]["name"]!!)
            
            self.statusOutlet.text = currPlace_dict["title"] as? String
            //print(latitude) // for testing
            
            //Centralize the view
            let place_location = CLLocationCoordinate2D(latitude: (currPlace_dict["lat"] as? Double)!, longitude: (currPlace_dict["long"] as? Double)!)
            let region = MKCoordinateRegion(center: place_location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            //Remove existing Annotations
            let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
            mapView.removeAnnotations(annotationsToRemove)
            
            //Adds an Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = place_location
            self.mapView.addAnnotation(annotation)
            
        } else if fromSegue_Global == "bmPlaceSegue" { //If user is looking at a bookmarked place
            
            self.saveButtonOutlet.enabled = false
            self.renameButtonOutlet.enabled = true
            self.mapView.showsUserLocation = true
            
            //Set Current Place
            currPlace_dict["lat"] = NSString(string: String(self.bookmarkedArray[activePlace_GLOBAL]["lat"]!!)).doubleValue
            currPlace_dict["long"] = NSString(string: String(self.bookmarkedArray[activePlace_GLOBAL]["long"]!!)).doubleValue
            currPlace_dict["title"] = String(self.bookmarkedArray[activePlace_GLOBAL]["name"]!!)
            
            self.statusOutlet.text = currPlace_dict["title"] as? String
            //print(latitude) // for testing
            
            //Centralize the view
            let place_location = CLLocationCoordinate2D(latitude: (currPlace_dict["lat"] as? Double)!, longitude: (currPlace_dict["long"] as? Double)!)
            let region = MKCoordinateRegion(center: place_location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            //Remove existing Annotations
            let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
            mapView.removeAnnotations(annotationsToRemove)
            
            //Adds an Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = place_location
            self.mapView.addAnnotation(annotation)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigateButtonOutlet.tintColor = UIColor.greenColor()
        self.renameButtonOutlet.tintColor = UIColor.greenColor()
        
        self.getPermData()
        
        //Create Map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Standard
        
        //Place Initial Pin
        self.placeInitialPin()
        
        /*
        //Allowing User to add Annotation
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.5
        self.mapView.addGestureRecognizer(uilpgr)
        */
        
    }
    
    /*
    override func viewDidAppear(animated: Bool) {
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        
        mapView.removeAnnotations(annotationsToRemove)
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        
        //Activate Saved Button and Rename Segue button
        self.saveButtonOutlet.enabled = true
        self.renameButtonOutlet.enabled = true
        
        //Date Extraction
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        if newState == MKAnnotationViewDragState.Ending {
            let droppedAt = view.annotation?.coordinate
            
            //Reverse Geocoder to get the address:
            let location_lookup = CLLocation(latitude: droppedAt!.latitude, longitude: droppedAt!.longitude)
            
            //print(droppedAt!.latitude)
            //print(droppedAt!.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location_lookup) { (placemarks, error) -> Void in
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
                if title == "" || title == " " {
                    title = "Unknown Address"
                    
                }
                
                self.places_dict = ["name":String(dateComponents.month)+"/"+String(dateComponents.day)+" "+String(dateComponents.hour)+":"+String(dateComponents.minute)+", "+title,"lat":String(droppedAt!.latitude),"long":String(droppedAt!.longitude)]
                
                self.statusOutlet.text = title
                
                //Set current Place
                self.currPlace_dict["lat"] = droppedAt!.latitude
                self.currPlace_dict["long"] = droppedAt!.longitude
                self.currPlace_dict["title"] = title

                //print(self.places_dict) //for testing
                //print(self.places_dict["name"]!)
            }
        }
    }

    //Function for Updating User location to center on User:
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Location Zoom
        let location = locations.last
        let user_location = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: user_location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        //Stops updating
        self.locationManager.stopUpdatingLocation()
        
        //Remove existing Annotations
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations(annotationsToRemove)
        
        //Adds an Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = user_location
        //annotation.title = "New Place"
        //annotation.subtitle = "One day I'll own here..."
        self.mapView.addAnnotation(annotation)
        
        //Date Extraction
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: date)
        
        //print("test")
        
        //Reverse Geocoder to get the address:
        let location_lookup = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location_lookup) { (placemarks, error) -> Void in
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
            if title == "" || title == " " {
                title = "Unknown Address"
                
            }
            
            self.places_dict = ["name":String(dateComponents.month)+"/"+String(dateComponents.day)+" "+String(dateComponents.hour)+":"+String(dateComponents.minute)+", "+title,"lat":String(annotation.coordinate.latitude),"long":String(annotation.coordinate.longitude)]
            
            self.statusOutlet.text = title
            
            //Set current Place
            self.currPlace_dict["lat"] = annotation.coordinate.latitude
            self.currPlace_dict["long"] = annotation.coordinate.longitude
            self.currPlace_dict["title"] = title
            
            //print(self.places_dict) //for testing
            //print(self.places_dict["name"]!)
            
        }
    }
    
}