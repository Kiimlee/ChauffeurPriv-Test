//
//  TableViewSearchBar.swift
//  MapBoxApp
//
//  Created by Willy Kim on 28/04/2017.
//  Copyright © 2017 Willy Kim. All rights reserved.
//

import UIKit
import Mapbox
import MapKit

class TableViewSearchBar : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var mapViewMapBox: MGLMapView? = nil
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // postal code
            selectedItem.postalCode ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace
        )
        return addressLine
    }
}

extension TableViewSearchBar : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        })
    }
}

extension TableViewSearchBar {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
}

extension TableViewSearchBar {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        
        mapViewMapBox?.latitude = selectedItem.coordinate.latitude
        mapViewMapBox?.longitude = selectedItem.coordinate.longitude
        mapViewMapBox?.zoomLevel = 14
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: (mapViewMapBox?.latitude)!, longitude: (mapViewMapBox?.longitude)!)
        point.title = selectedItem.name
        point.subtitle = selectedItem.title
        mapViewMapBox?.addAnnotation(point)

        dismiss(animated: true, completion: nil)
    }
}
