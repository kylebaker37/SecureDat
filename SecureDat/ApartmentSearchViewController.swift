//
//  ApartmentSearchViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class ApartmentSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var apts: [Apartment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.findApts()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.findApts()
    }
    
    func findApts() {
        self.apts = []
        let name = self.searchBar.text
        Backend.find_apartment(aptname: name!, completionHandler: {
            resultApts in
            DispatchQueue.main.async {
                if (!resultApts.isEmpty){
                    for apt in resultApts {
                        self.apts.append(apt)
                    }
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
                    Helpers.createAlert(title: "Search Error", message: "Could not find apartment with that name", vc: self)
                }
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apts.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ApartmentListCell = self.tableView.dequeueReusableCell(withIdentifier: "apartmentListCell") as! ApartmentListCell
        let apt = self.apts[indexPath.row]
        cell.aptNameLabel.text = self.apts[indexPath.row].name
        cell.latitude =  apt.latitude
        cell.longitude = apt.longitude
        cell.reloadMap(lat: cell.latitude, long: cell.longitude)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 200.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let apt = self.apts[indexPath.row]
        let confirmAlert = UIAlertController(title: "Confirm", message: "Join this apartment?", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let current_uid = UserDefaults.standard.value(forKey: "uid")! as! Int
            Backend.add_users_to_apartment(uids: [current_uid], aid: apt.id, completionHandler: {
                status in
                DispatchQueue.main.async {
                    if (status != -1){
                        self.performSegue(withIdentifier: "apartmentJoinedToHome", sender: self)
                    }else{
                        Helpers.createAlert(title: "Join Error", message: "Could not join the apartment", vc: self)
                    }
                    
                }

            })
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(confirmAlert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        return
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
