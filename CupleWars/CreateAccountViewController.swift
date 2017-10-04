//
//  CreateAccountViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/22/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CreateAccountViewController: UIViewController {

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
//        let storage = Storage.storage().reference(forURL: "gs://cuplewars.appspot.com")
//        userStorage?.userStorage = storage.child("users")
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidInfoLabel: UILabel!

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        usernameTextField.layer.borderWidth = 0
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        if password.characters.count < 6 {
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Password must contain at least 6 characters or more."
            invalidInfoLabel.textColor = .red
        }
        
        if username.isEmpty && email.isEmpty && password.isEmpty {
            
            usernameTextField.layer.borderWidth = 1.5
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.layer.borderColor = UIColor.red.cgColor
            
            emailTextField.layer.borderWidth = 1.5
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderColor = UIColor.red.cgColor
            
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            
        } else if username.isEmpty && email.isEmpty {
            
            usernameTextField.layer.borderWidth = 1.5
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.layer.borderColor = UIColor.red.cgColor
            
            emailTextField.layer.borderWidth = 1.5
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            
        } else if username.isEmpty && password.isEmpty {
            
            usernameTextField.layer.borderWidth = 1.5
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.layer.borderColor = UIColor.red.cgColor
            
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
            
        } else if email.isEmpty && password.isEmpty {
            
            emailTextField.layer.borderWidth = 1.5
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderColor = UIColor.red.cgColor
            
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
        } else if username.isEmpty {
            
            usernameTextField.layer.borderWidth = 1.5
            usernameTextField.layer.cornerRadius = 5
            usernameTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
        } else if email.isEmpty || !email.contains("@") {
            
            emailTextField.layer.borderWidth = 1.5
            emailTextField.layer.cornerRadius = 5
            emailTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
        } else if password.isEmpty {
            
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Please enter a valid Username, Email, and/or Password."
            invalidInfoLabel.textColor = .red
        } else {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
                
                if let user = user {
                    
                    guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { return }
                    changeRequest.displayName = username
                    changeRequest.commitChanges(completion: nil)
                    
                    let userInfo: [String: Any] = ["uid": user.uid,
                                                   "username": username]
                    
                    self.ref.child("Users").child(user.uid).setValue(userInfo)
                }
                print("Success")
            
                let alertController = UIAlertController(title: "Account Created", message: "Account successfully created!", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "loginVC")
                    DispatchQueue.main.async {
                        self.present(viewController, animated: true, completion: nil)
                    }
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
