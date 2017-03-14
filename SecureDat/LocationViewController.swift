import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController {
    
    fileprivate var location = MKPointAnnotation()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    @IBAction func locationEnabledChanged(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }

    }

    
    
}

// MARK: - CLLocationManagerDelegate
extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.location = annotation
        
        if UIApplication.shared.applicationState == .active {
            //mapView.showAnnotations(self.locations, animated: true)
            print("App is in foreground. New location is %@", mostRecentLocation)
        } else {
            print("App is in background. New location is %@", mostRecentLocation)
        }
    }
    
}

