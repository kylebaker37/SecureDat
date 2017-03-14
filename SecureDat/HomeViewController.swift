//
//  HomeViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //location updating stuff
    fileprivate var location = MKPointAnnotation()
    var poll_count: Int = 0
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()

    var current_user: User?
    var apartment: Apartment?
    
    @IBOutlet weak var noApartmentView: UIView!
    @IBOutlet weak var apartmentView: UIView!
    @IBOutlet weak var createApartmentButton: UIButton!
    @IBOutlet weak var currentUserLabel: UILabel!
    
    @IBOutlet weak var apartmentNameLabel: UILabel!
    
    @IBOutlet weak var roommatesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserLabel.isHidden = true
        self.apartmentView.isHidden = true
        self.noApartmentView.isHidden = true
        
        let current_uid = UserDefaults.standard.value(forKey: "uid")! as! Int
        Backend.get_user(id: current_uid, completionHandler: {
            current_user in
            DispatchQueue.main.async {
                self.current_user = current_user
                UserDefaults.standard.setValue(current_user.at_home, forKey: "at_home")
                self.currentUserLabel.text = "Logged in as " + current_user.username
                self.currentUserLabel.isHidden = false
                
                if(self.current_user?.aid == nil){
                    self.apartmentView.isHidden = true
                    self.noApartmentView.isHidden = false
                }else{
                    Backend.get_apartment(id: (self.current_user?.aid)!, completionHandler: {
                        apartment in
                        
                        DispatchQueue.main.async{
                            self.apartment = apartment
                            UserDefaults.standard.setValue(apartment.id, forKey: "aid")
                            UserDefaults.standard.setValue(apartment.latitude, forKey: "latitude")
                            UserDefaults.standard.setValue(apartment.longitude, forKey: "longitude")
                            //location updating
                            self.locationManager.startUpdatingLocation()
                            self.apartmentNameLabel.text = "Apartment: " + apartment.name
                            self.apartmentView.isHidden = false
                            self.noApartmentView.isHidden = true
                            self.roommatesTableView.reloadData()
                        }
                    })
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.apartment == nil){
            return 0
        }else{
            return (self.apartment?.users.count)! // your number of cell here
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomiesCell", for: indexPath) as! RoommatesTableViewCell
        cell.usernameLabel.text = self.apartment?.users[indexPath.row].username
        if(self.apartment?.users[indexPath.row].at_home == true){
            cell.atHomeLabel.text = "HOME"
        }else{
            cell.atHomeLabel.text = "AWAY"
        }
        
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFile = self.files[indexPath.row]
        performSegue(withIdentifier: "videoListToVideo", sender: self)
    }*/
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        // Also add to our map so we can remove old values later
        self.location = annotation
        let userLocation = CLLocation(latitude: mostRecentLocation.coordinate.latitude, longitude: mostRecentLocation.coordinate.longitude)
        var distance: Float = 0.0
        
        if UIApplication.shared.applicationState == .active {
            //mapView.showAnnotations(self.locations, animated: true)
            print("App is in foreground. New location is %@", mostRecentLocation)
            //check if user is within proper range of apartment and update backend if current status differs...
            
            let apartmentLocation = CLLocation(latitude: (self.apartment?.latitude)!, longitude: (self.apartment?.longitude)!)
            distance = Float(userLocation.distance(from: apartmentLocation) / 1609)
            
            //if 5 updates have been made and app is in foreground, check backend for update
            if (self.poll_count % 5 == 0){
                Backend.get_apartment(id: (self.current_user?.aid)!, completionHandler: {
                    apartment in
                    DispatchQueue.main.async{
                        self.apartment = apartment
                        UserDefaults.standard.setValue(apartment.id, forKey: "aid")
                        UserDefaults.standard.setValue(apartment.latitude, forKey: "latitude")
                        UserDefaults.standard.setValue(apartment.longitude, forKey: "longitude")
                        //location updating
                        self.apartmentNameLabel.text = "Apartment: " + apartment.name
                        self.roommatesTableView.reloadData()
                    }
                })
            }
            
        } else {
            print("App is in background. New location is %@", mostRecentLocation)
            //check if user is within proper range of apartment and update backend if current status differs...
            let apartmentLocation = CLLocation(latitude: UserDefaults.standard.value(forKey: "latitude")! as! Double, longitude: UserDefaults.standard.value(forKey: "longitude")! as! Double)
            distance = Float(userLocation.distance(from: apartmentLocation) / 1609)
        }
        
        let old_at_home = UserDefaults.standard.value(forKey: "at_home")! as! Bool
        let uid = UserDefaults.standard.value(forKey: "uid")! as! Int
        print("old at_home: \(old_at_home)")
        print("distance: \(distance)")
        if (distance > 1){
            //TODO...
            if (old_at_home){
                print("updating user location status to AWAY")
                //update backend with at_home = false
                Backend.update_user_location_status(uid: uid, at_home: false)
                //update nsuserdefaults with at_home = false
                UserDefaults.standard.setValue(false, forKey: "at_home")
                self.current_user?.at_home = false
                
            }
            //user is away
        }else{
            //TODO...
            if (!old_at_home){
                print("updating user location status to HOME")
                //update backend with at_home = true
                Backend.update_user_location_status(uid: uid, at_home: true)
                //update nsurserdefaults with at_home = true
                UserDefaults.standard.setValue(true, forKey: "at_home")
                self.current_user?.at_home = true
            }
            //user is home
        }
        
        //update polling count
        if (self.poll_count < 1000){
            self.poll_count += 1
        }else{
            self.poll_count = 0
        }
    }
}

