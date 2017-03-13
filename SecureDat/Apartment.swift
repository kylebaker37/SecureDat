//
//  Apartment.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation

class Apartment{
    var id: Int = -1    //initialized to dummy value
    var latitude: Double?
    var longitude: Double?
    var name: String
    var password: String
    var users: [Int] = []   //user ids... currently would be adding them using add_users_to_apartment API call
    
    init(name: String, password: String){
        self.name = name
        self.password = password
        
    }
    
    init(id: Int){
        self.id = id
        //TODO will get values from backend based on id...
        self.name = "dummy"
        self.password = "dummy"
    }
}
