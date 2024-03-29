//
//  AddRoommatesViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class AddRoommatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    
    var aptId: Int!
    var users: [User] = []
    
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
        self.findUsers(showAlert: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.findUsers(showAlert: false)
    }
    
    func findUsers(showAlert: Bool) {
        let email = self.searchBar.text
        self.users = []
        Backend.find_user_by_email(email: email!, completionHandler: {
            resultUsers in
            DispatchQueue.main.async {
                if (!resultUsers.isEmpty){
                    for user in resultUsers {
                        self.users.append(user)
                    }
                    self.tableView.reloadData()
                }else{
                    self.tableView.reloadData()
                    if (showAlert){
                        Helpers.createAlert(title: "Search Error", message: "Could not find user with that email", vc: self)
                    }
                }
                    
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UsersListCell = self.tableView.dequeueReusableCell(withIdentifier: "usersListCell") as! UsersListCell
        cell.username.text = self.users[indexPath.row].username
        cell.email.text = self.users[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let user = self.users[indexPath.row]
        let userName = self.users[indexPath.row].username
        let addUserMsg = "Add " + userName + " to this apartment?"
        let confirmAlert = UIAlertController(title: "Confirm", message: addUserMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            Backend.add_users_to_apartment(uids: [user.id], aid: self.aptId, completionHandler: {
                status in
                DispatchQueue.main.async {
                    if (status != -1){
                        Helpers.createAlert(title: "Success!", message: "Successfully added user to the apartment", vc: self)
                    }
                    return
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
}
