//
//  HomeViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var current_user: User?{
        willSet(current_user) {}
        didSet {
            self.currentUserLabel.text = self.current_user?.username
            self.currentUserLabel.isHidden = false
        }
    }
    
    @IBOutlet weak var noApartmentView: UIView!
    @IBOutlet weak var createApartmentButton: UIButton!
    @IBOutlet weak var apartmentView: UIView!
    @IBOutlet weak var currentUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserLabel.isHidden = true
        self.apartmentView.isHidden = true
        self.noApartmentView.isHidden = true
        
        let current_uid = UserDefaults.standard.value(forKey: "uid")! as! Int
        Backend.get_user(id: current_uid, completionHandler: {
            current_user in
            self.current_user = current_user
            if(self.current_user?.aid == nil){
                self.apartmentView.isHidden = true
                self.noApartmentView.isHidden = false
            }else{
                self.apartmentView.isHidden = false
                self.noApartmentView.isHidden = true
            }
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinApartmentButtonDidTouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "homeToApartmentSearch", sender: self)
    }

    @IBAction func createApartmentDidTouchUpInside(_ sender: Any) {
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
