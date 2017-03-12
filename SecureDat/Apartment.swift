//
//  Apartment.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation

class Apartment{
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var name: String = "Default Apartment Name"
    var password: String = "password"   //currently just password for all until implemented in API
    var users: [Int] = []   //user ids... currently would be adding them using add_users_to_apartment API call
}
