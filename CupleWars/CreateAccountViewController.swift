//
//  CreateAccountViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/22/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidInfoLabel: UILabel!
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                
            usernameTextField.layer.borderWidth = 1.5
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.layer.borderColor = UIColor.red.cgColor
                
            emailTextField.layer.borderWidth = 1.5
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderColor = UIColor.red.cgColor
                
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
                
            invalidInfoLabel.text = "* Please enter valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("Success")
        }
    }
}
