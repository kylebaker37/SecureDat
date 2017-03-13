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

class ApartmentLocationViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, MapDelegate {
    @IBOutlet var mapView: GMSMapView!

    var map: Map!
    var locationManager: CLLocationManager!
    var apt: Apartment!
    
    override func viewDidLoad() {
        map = Map(mapView: mapView)
        map.delegate = self
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
    
    func createApartmentAtLocation() {
        apt.latitude = map.lat
        apt.longitude = map.long
        Backend.add_apartment(aptname: apt.name, latitude: apt.latitude!, longitude: apt.longitude!, completionHandler: {
            newAptId in
            DispatchQueue.main.async {
                if (newAptId != -1){
                    self.apt.id = newAptId
                    let current_uid = UserDefaults.standard.value(forKey: "uid")! as! Int
                    Backend.add_users_to_apartment(uids: [current_uid], aid: newAptId)
                    self.performSegue(withIdentifier: "apartmentLocationToAddRoommates", sender: self)
                    print(newAptId)
                }else{
                    Helpers.createAlert(title: "Apartment Creation Failed", message: "???", vc: self)
                }
                
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "apartmentLocationToAddRoommates"){
            let vc = segue.destination as! AddRoommatesViewController
            vc.aptId = self.apt.id
        }
    }

}
