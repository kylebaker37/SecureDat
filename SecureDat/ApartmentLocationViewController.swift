//
//  ApartmentLocationViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps

class ApartmentLocationViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: GMSMapView!

    var map: Map!
    var locationManager: CLLocationManager!
    var lat = 37.33233141
    var long = -122.0312186
    
    override func viewDidLoad() {
        map = Map(mapView: mapView)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
