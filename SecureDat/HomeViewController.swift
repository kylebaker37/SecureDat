//
//  HomeViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
