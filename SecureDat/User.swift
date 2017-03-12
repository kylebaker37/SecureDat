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
    var password: String?
    var email: String
    var phone: String
    var aid: Int?
    
    init(username: String, password: String, email: String, phone: String){
        self.id = -1;   //stays -1 until given id by backend
        self.username = username
        self.password = password
        self.email = email
        self.phone = phone
    }
    
    //from login api call
    init(id: Int, username: String, email: String, phone: String, aid: Int?){
        self.id = id
        self.username = username
        self.email = email
        self.phone = phone
        self.aid = aid
    }
    
    //for initialization from only id...
    init(id: Int){
        self.id = id
        //TODO... will make request to backend and then update all values
        //these are all dummies below for now
        self.username = "dummy"
        self.email = "dummy"
        self.phone = "dummy"
    }
}
