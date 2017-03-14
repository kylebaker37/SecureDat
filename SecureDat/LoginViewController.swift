//
//  LoginViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonDidTouchUpInside(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        if (username.isEmpty) {
            Helpers.createAlert(title: "Login Failed", message: "Please enter a username", vc: self)
        }else if(password.isEmpty){
            Helpers.createAlert(title: "Login Failed", message: "Please enter a password", vc: self)
        }else{
            Backend.login(username: username, password: password, completionHandler: {
                user in
                DispatchQueue.main.async {
                    if (user != nil){
                        print((user?.username)! as String)
                        UserDefaults.standard.setValue(user?.id, forKey: "uid")
                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                    }else{
                        Helpers.createAlert(title: "Login Failed", message: "Username does not match password", vc: self)
                    }
                
                }
            })
        }
    }

    @IBAction func signupButtonDidTouchUpInside(_ sender: Any) {
        performSegue(withIdentifier: "loginToSignup", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    // MARK: - Navigation
     
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
