//
//  Backend.swift
//  SecureDat
//
//  Created by Markus Notti on 3/3/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import Foundation

class Backend{
    static let HOST = "http://172.91.91.149"
    static let PORT = "80"
    
    
    //MARK: - user API
    //returns uid if user is successfully created, else returns -1
    static func add_user(username: String, password: String, email: String, phone: String, completionHandler: @escaping (Dictionary<String, Any>) -> ()){
        let json = ["username":username, "password":password, "email":email, "phone":phone]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/add_user")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    completionHandler(["result": "error", "message": "Failed in backend", "id":-1])
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let status = result!["result"] as! String
                    let message = result!["message"] as! String
                    let id = result!["id"] as! Int
                    completionHandler(["result": status, "message": message, "id": id])
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                    completionHandler(["result": "error", "message": "Failed in swift catch", "id":-1])
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
    
    static func get_user(id: Int, completionHandler: @escaping(User) -> ()){
        let url = NSURL(string: HOST + ":" + PORT + "/api/user?uid=" + String(id))!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                print("Result -> \(result)")
                let user = User(id: result!["id"] as! Int, username: result!["username"] as! String, email: result!["email"] as! String, phone: result!["phone"] as! String, aid: result!["aid"] as? Int)
                user.at_home = result!["at_home"] as! Bool
                print("passing user into completion handler for get user")
                completionHandler(user)
                
                
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
    }
    
    static func find_user_by_email(email: String, completionHandler: @escaping([User]) -> ()){
        let url = NSURL(string: HOST + ":" + PORT + "/api/find_user_by_email?email=" + email)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:AnyObject]]
                print("Result -> \(result)")
                var users: [User] = []
                for userObj in result!
                {
                    let user = User(id: userObj["id"] as! Int, username: userObj["username"] as! String, email: userObj["email"] as! String, phone: userObj["phone"] as! String, aid: userObj["aid"] as? Int)
                    users.append(user)
                }

                completionHandler(users)
                
                
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
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
    
    static func login(username: String, password: String, completionHandler: @escaping (User?) -> ()){
        let json = ["username":username, "password":password]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/login")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    completionHandler(nil)
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let result_message = result!["result"] as! String
                    if (result_message == "error"){
                        completionHandler(nil)
                    }else if(result_message != "success"){
                        completionHandler(nil)
                    }else{
                        print("Successful login -> \(result)")
                        let u = User(id: result!["id"] as! Int, username: result!["username"] as! String, email: result!["email"] as! String, phone: result!["phone"] as! String, aid: result!["aid"] as? Int)
                        print("passing logged in user to completion handler")
                        completionHandler(u)
                    }
                    
                } catch {
                    print("Error -> \(error)")
                    completionHandler(nil)
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }

    //MARK: - Apartment API
    static func get_apartment(id: Int, completionHandler: @escaping(Apartment) -> ()){
        let url = NSURL(string: HOST + ":" + PORT + "/api/apartment?aid=" + String(id))!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                print("Result -> \(result)")
                
                let aptname = result!["aptname"] as! String
                let latitude = result!["latitude"] as? Double
                let longitude = result!["longitude"] as? Double
                let userids = result!["userids"] as? [Int]
                let usernames = result!["usernames"] as? [String]
                let users_at_home = result!["users_at_home"] as? [Bool]
                
                let apartment = Apartment(id: id)
                apartment.name = aptname
                apartment.latitude = latitude
                apartment.longitude = longitude
                if (userids != nil){
                    var users: [User] = []
                    for (i, userid) in userids!.enumerated(){
                        let u = User(id: userid)
                        u.username = usernames![i]
                        u.at_home = users_at_home![i]
                        u.aid = id
                        users.append(u)
                    }
                    apartment.users = users
                }
                print("passing apartment to completion handler")
                completionHandler(apartment)
                
                
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
    }
    
    static func find_apartment(aptname: String, completionHandler: @escaping([Apartment]) -> ()){
        let url = NSURL(string: HOST + ":" + PORT + "/api/find_apartment?aptname=" + aptname)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:AnyObject]]
                print("Result -> \(result)")
                var apts: [Apartment] = []
                for aptObj in result!
                {
                    let apt = Apartment(id: aptObj["aid"] as! Int, name: aptObj["aptname"] as! String, latitude: aptObj["latitude"] as! Double, longitude: aptObj["longitude"] as! Double)
                    apts.append(apt)
                }

                completionHandler(apts)
                
                
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
    }

    
    //adds apartment, returns an ID for the new apartment
    static func add_apartment(aptname: String, latitude: Double, longitude: Double, completionHandler: @escaping (Int) -> ()){
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
    
    static func add_users_to_apartment(uids: [Int], aid: Int, completionHandler: @escaping (Int) -> ()){
        let json = ["aid":aid, "uids":uids] as [String : Any]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let request = Backend.prepare_json_request(jsonData: jsonData, method: "POST", endpoint: "/api/add_users_to_apartment")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    completionHandler(-1)
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    if ((result?["success"]) != nil) {
                        completionHandler(1)
                    }
                    else {
                        completionHandler(-1)
                    }
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
    
    //MARK: - Video API
    static func get_videos(completionHandler: @escaping ([String], [String]) -> ()) {
        let url = NSURL(string: HOST + ":" + PORT + "/api/videos")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                let videos = result!["videos"] as! [String]
                let events = result!["events"] as! [String]
                completionHandler(videos, events)
                print("Result -> \(result)")
                
            } catch {
                print("Error -> \(error)")
                return
            }
        }
        task.resume()
    }
    
    //MARK: - Helpers
    
    static func prepare_json_request(jsonData: Data, method: String, endpoint: String) -> NSMutableURLRequest{
        let url = NSURL(string: HOST + ":" + PORT + endpoint)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        return request
    }


}
