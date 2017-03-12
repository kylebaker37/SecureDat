//
//  Map.swift
//  SecureDat
//
//  Created by Richard Guzikowski on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation
import GoogleMaps

protocol MapDelegate {
    func createApartmentAtLocation()
}

class Map: NSObject, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    var marker: GMSMarker!
    var lat = 34.068971
    var long = -118.444033
    var radius = 5.0
    var locationManager: CLLocationManager!
    var showMarkers: Bool!
    var delegate: MapDelegate?
    var betCount: Int = 0
    var reloadMap = false
    
    let betIconWagered = GMSMarker.markerImage(with: UIColor.green)
    let betIconMediated = GMSMarker.markerImage(with: UIColor.purple)
    let betIconNormal = GMSMarker.markerImage(with: UIColor.blue)
    
    init(mapView: GMSMapView!) {
        super.init()
        
        self.mapView = mapView
        
        self.mapView.delegate = self;
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = true
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestAlwaysAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func updateCamera(lat: Double, long: Double) {
        camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        mapView.camera = camera
    }
    
    func updateCameraAnimation(coord: CLLocationCoordinate2D) {
        let cameraUpdate = GMSCameraUpdate.setTarget(coord)
        mapView.animate(with: cameraUpdate)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("SetLocationMarker", owner: self, options: nil)?.first! as! UIView
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapView.clear()
        self.marker = GMSMarker()
        self.marker.position = coordinate
        self.marker.title = "Your Location"
        self.marker.map = self.mapView
        self.mapView.delegate = self
        self.mapView.selectedMarker = self.marker
        self.updateCameraAnimation(coord: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) -> UIView? {
        self.delegate!.createApartmentAtLocation()
        return UIView()
    }
    
    func locationMarker(lat: Double, long: Double) {
        self.marker = GMSMarker()
        self.marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.marker.title = "Your Location"
        self.marker.map = self.mapView
        self.mapView.selectedMarker = self.marker
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        long = userLocation.coordinate.longitude
        lat = userLocation.coordinate.latitude
        updateCamera(lat: lat, long: long)
        locationMarker(lat: lat, long: long)
        locationManager.stopUpdatingLocation()
    }
}
