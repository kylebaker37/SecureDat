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
        //printMessagesForUser()
        addUser(username: "markus", password: "password", email: "markusnotti@gmail.com", phone: "9253302530")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //TESTING BASIC BACKEND INTERACTION
    
    func addUser(username: String, password: String, email: String, phone: String) -> Void{
        let json = ["username":username, "password":password, "email":email, "phone":phone]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let url = NSURL(string: "http://127.0.0.1:5000/api/add_user")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
    
    func printMessagesForUser() -> Void {
        let json = ["user":"larry"]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            let url = NSURL(string: "http://127.0.0.1:5000/api/get_messages")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(error)")
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                }
            }
            
            task.resume()
        } catch {
            print(error)
        }
    }


}

