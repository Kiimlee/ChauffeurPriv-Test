//
//  ViewController.swift
//  MapBoxApp
//
//  Created by Willy Kim on 28/04/2017.
//  Copyright © 2017 Willy Kim. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import MapboxGeocoder
import MapKit

class ViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    var mapViewMapKit = MKMapView()
    var locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var region: MKCoordinateRegion?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initializeMap()
        getDataFromMapKit()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "TableViewSearchBar") as! TableViewSearchBar
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapViewMapKit
        locationSearchTable.mapViewMapBox = mapView
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
    
        if let userCurrentLatitude = locationManager.location?.coordinate.latitude {
            if let userCurrentLongitude = locationManager.location?.coordinate.longitude {
                mapView.delegate = self
                mapView.latitude = userCurrentLatitude
                mapView.longitude = userCurrentLongitude
                mapView.zoomLevel = 14
                let point = MGLPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: userCurrentLatitude, longitude: userCurrentLongitude)
                point.title = "User's position"
                point.subtitle = "That's pretty cool hun ?"
                mapView.addAnnotation(point)
            }
        }
    }
    
    func getDataFromMapKit() {
        mapViewMapKit.mapType = .standard
        mapViewMapKit.frame = view.frame
        mapViewMapKit.delegate = self
    }
    
    @nonobjc func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let currentRegion = MKCoordinateRegion(center: location.coordinate, span: span)
            region = currentRegion
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Errors:" + error.localizedDescription)
    }
}
