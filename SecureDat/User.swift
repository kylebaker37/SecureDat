//
//  User.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation

class User{
    //TODO
    var id: Int    //initialized to dummy value
    var username: String
    var password: String
    var email: String
    var phone: String
    
    init(username: String, password: String, email: String, phone: String){
        self.id = -1;   //stays -1 until given id by backend
        self.username = username
        self.password = password
        self.email = email
        self.phone = phone
    }
    
    //for initialization from only id...
    init(id: Int){
        self.id = id
        //TODO... will make request to backend and then update all values
        //these are all dummies below for now
        self.username = "dummy"
        self.password = "dummy"
        self.email = "dummy"
        self.phone = "dummy"
    }
}
