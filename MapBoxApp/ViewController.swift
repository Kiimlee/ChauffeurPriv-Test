//
//  ViewController.swift
//  MapBoxApp
//
//  Created by Willy Kim on 28/04/2017.
//  Copyright © 2017 Willy Kim. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MGLMapView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeMap()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func initializeMap() {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    
        let userLatitude = locationManager.location?.coordinate.latitude
        let userLongitude = locationManager.location?.coordinate.longitude
        
        mapView.delegate = self
        mapView.latitude = userLatitude!
        mapView.longitude = userLongitude!
        mapView.zoomLevel = 14
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitude!)
        point.title = "User's position"
        point.subtitle = "That's pretty cool hun ?"
        mapView.addAnnotation(point)
    }
}
