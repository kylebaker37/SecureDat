//
//  SignupViewController.swift
//  SecureDat
//
//  Created by Markus Notti on 3/11/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    //Labels
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordConfirmationLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    //Text fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions
    
    @IBAction func createAccountButtonDidTouchUpInside(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        let password_confirmation = passwordConfirmationTextField.text!
        let email = emailTextField.text!
        let phone = phoneTextField.text!
        
        
        if (username.isEmpty) {
            Helpers.createAlert(title: "Signup Failed", message: "Please enter a username", vc: self)
        }else if(password.isEmpty){
            Helpers.createAlert(title: "Signup Failed", message: "Please enter a password", vc: self)
        }else if(password_confirmation.isEmpty){
            Helpers.createAlert(title: "Signup Failed", message: "Please enter a password", vc: self)
        }else if(password != password_confirmation){
            Helpers.createAlert(title: "Signup Failed", message: "Password does not match password confirmation", vc: self)
        }else if(email.isEmpty){
            Helpers.createAlert(title: "Signup Failed", message: "Please enter an email", vc: self)
        }else if(phone.isEmpty){
            Helpers.createAlert(title: "Signup Failed", message: "Please enter a valid phone number", vc: self)
        }else{
            Backend.add_user(username: username, password: password, email: email, phone: phone, completionHandler: {
                result_dict in
                DispatchQueue.main.async {
                    if (result_dict["result"]! as! String == "success"){
                        print((result_dict["message"])! as! String)
                        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                    }else{
                        Helpers.createAlert(title: "Account Creation Failed", message: result_dict["message"]! as! String, vc: self)
                    }
                    
                }
            })
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
