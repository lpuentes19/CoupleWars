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
        
        usernameTextField.layer.borderWidth = 0
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            
            usernameTextField.layer.borderWidth = 1.5
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            invalidInfoLabel.textAlignment = .center
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            
            emailTextField.layer.borderWidth = 1.5
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            return
        }
        
        if let password = passwordTextField.text?.characters {
            if password.count < 8 {
                passwordTextField.layer.borderWidth = 1.5
                passwordTextField.layer.cornerRadius = 5
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                
                invalidInfoLabel.text = "* Password must contain at least 8 characters."
                invalidInfoLabel.textColor = .red
            }
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
