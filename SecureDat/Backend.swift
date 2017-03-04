//
//  Backend.swift
//  SecureDat
//
//  Created by Markus Notti on 3/3/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation

class Backend{
    static let HOST = "http://127.0.0.1"
    static let PORT = "5000"
    
    //returns uid if user is successfully created, else returns -1
    static func add_user(username: String, password: String, email: String, phone: String, completionHandler: @escaping (Int) -> ()){
        let json = ["username":username, "password":password, "email":email, "phone":phone]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/add_user")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    completionHandler(-1)
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let uid = result!["id"] as! Int
                    completionHandler(uid)
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                    completionHandler(-1)
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
    
    //
    static func update_user_location_status(uid: Int, at_home: Bool){
        let json = ["uid":uid, "at_home":at_home] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/update_user_location_status")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(result)")
                    return
                    
                } catch {
                    print("Error -> \(error)")
                    return
                }
            }
            task.resume()
        } catch {
            print(error)
        }

    }
    
    //returns user location status, true if at home and false if away
    static func user_location_status(uid: Int, completionHandler: @escaping (Bool) -> ()){
        let url = NSURL(string: HOST + ":" + PORT + "/api/user_location_status?uid=" + String(uid))!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                let at_home = result!["at_home"] as! Bool
                completionHandler(at_home)
                print("Result -> \(result)")
                
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
    }

    
    //adds apartment, returns an ID for the new apartment
    static func add_apartment(aptname: String, latitude: Float, longitude: Float, completionHandler: @escaping (Int) -> ()){
        let json = ["aptname":aptname, "latitude":latitude, "longitude":longitude] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/add_apartment")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    completionHandler(-1)
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let uid = result!["id"] as! Int
                    completionHandler(uid)
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                    completionHandler(-1)
                }
            }
            task.resume()
        } catch {
            print(error)
        }

    }
    
    static func add_users_to_apartment(uids: [Int], aid: Int){
        let json = ["aid":aid, "uids":uids] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/add_users_to_apartment")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(result)")
                    return

                } catch {
                    print("Error -> \(error)")
                    return
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }

    
    //returns latitude and longitude in a [Float], [-1, -1] if error
    static func apartment_location(aid: Int, completionHandler: @escaping ([Float]) -> ()){
        let url = NSURL(string: HOST + ":" + PORT + "/api/apartment_location?aid=" + String(aid))!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completionHandler([-1, -1])
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                let latitude = result!["latitude"] as! Float
                let longitude = result!["longitude"] as! Float
                completionHandler([latitude, longitude])
                print("Result -> \(result)")
                
            } catch {
                print("Error -> \(error)")
                completionHandler([-1, -1])
            }
        }
        task.resume()
    }
    
    static func prepare_json_request(jsonData: Data, method: String, endpoint: String) -> NSMutableURLRequest{
        let url = NSURL(string: HOST + ":" + PORT + endpoint)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        return request
    }


}
