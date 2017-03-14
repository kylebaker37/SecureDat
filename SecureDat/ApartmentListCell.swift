//
//  ApartmentListCell.swift
//  SecureDat
//
//  Created by Richard Guzikowski on 3/13/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class ApartmentListCell: UITableViewCell {
    @IBOutlet var mapview: GMSMapView!
    @IBOutlet var aptNameLabel: UILabel!
    
    var latitude: Double!
    var longitude: Double!
    var name: String!

    var camera: GMSCameraPosition!
    var marker: GMSMarker!
    
    func reloadMap(lat: Double, long: Double) {
        camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        mapview.camera = camera
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = mapview
    }
}
