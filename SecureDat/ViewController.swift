//
//  ViewController.swift
//  SecureDat
//
//  Created by Kyle Baker on 2/26/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        //TESTING BASIC BACKEND INTERACTION
        Backend.add_user(username: "test user", password: "password", email: "testuser@gmail.com", phone: "+19253302530", completionHandler: {
            uid in
            Backend.add_user(username: "test user2", password: "password", email: "testuser2@gmail.com", phone: "+19253302530", completionHandler: {
                uid2 in
                print("user created: \(uid)")
                Backend.add_apartment(aptname: "new apartment 5", latitude: 119.999, longitude: 25.8484, completionHandler: {
                    aid in
                    print("apartment created: \(aid)")
                    Backend.apartment_location(aid: aid, completionHandler: {
                        location in
                        print("lat: \(location[0]), long: \(location[1])")
                    })
                    Backend.add_users_to_apartment(uids: [uid, uid2], aid: aid)
                    Backend.update_user_location_status(uid: uid, at_home: false)
                    Backend.update_user_location_status(uid: uid, at_home: true)
                    Backend.user_location_status(uid: uid, completionHandler: {
                        at_home in
                        if at_home {
                            print("user \(uid) is at home")
                        }
                        else {
                            print("user \(uid) is not at home")
                        }
                    })

                })
            })
        })
        
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

