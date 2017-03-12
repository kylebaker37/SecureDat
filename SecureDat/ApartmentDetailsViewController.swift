//
//  ApartmentDetailsViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class ApartmentDetailsViewController: UIViewController {
    @IBOutlet var aptNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordConfirmationField: UITextField!
    

    var aptName: String!
    var password: String!
    var passwordConfirmation: String!
    var apt: Apartment!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: Any) {
        self.aptName = self.aptNameField.text
        self.password = self.passwordField.text
        self.passwordConfirmation = self.passwordConfirmationField.text
        if (self.aptName.isEmpty || self.password.isEmpty || self.passwordConfirmation.isEmpty){
            Helpers.createAlert(title: "Apartment Creation Failed", message: "Please enter all fields", vc: self)
            return
        }
        if (self.password != self.passwordConfirmation) {
            Helpers.createAlert(title: "Apartment Creation Failed", message: "Passwords do not match", vc: self)
            return
        }
        self.apt = Apartment(name: self.aptName, password: password)
        self.performSegue(withIdentifier: "apartmentDetailsToApartmentLocation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "apartmentDetailsToApartmentLocation"){
            let vc = segue.destination as! ApartmentLocationViewController
            vc.apt = self.apt
        }
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
