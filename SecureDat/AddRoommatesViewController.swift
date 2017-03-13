//
//  AddRoommatesViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class AddRoommatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchField: UITextField!
    
    var aptId: Int!
    var users = ["Bob", "Joe", "MarkusIsABitch"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UsersListCell = self.tableView.dequeueReusableCell(withIdentifier: "usersListCell") as! UsersListCell
        cell.username.text = self.users[indexPath.row]
        cell.email.text = self.users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 75.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let userName = self.users[indexPath.row]
        let addUserMsg = "Add " + userName + " to this apartment?"
        let confirmAlert = UIAlertController(title: "Confirm", message: addUserMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(confirmAlert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        return
    }

    @IBAction func searchForRoomate(_ sender: Any) {
        let email = self.searchField.text
        Backend.find_user_by_email(email: email!, completionHandler: {
            user in
            DispatchQueue.main.async {
                if (user.id != -1){
                    Backend.add_users_to_apartment(uids: [user.id], aid: self.aptId)
                    Helpers.createAlert(title: "Success!", message: "Successfully added user to the apartment", vc: self)
                }else{
                    Helpers.createAlert(title: "Search Error", message: "Could not find user with that email", vc: self)
                }
                
            }
        })

    }

}
