//
//  LoginViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/21/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Listen to see if we should keep user logged in
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if API.User.current_User != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "feedVC")
                self.present(viewController, animated: true, completion: nil)
                
            } else {
                print("User must sign in")
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonTapped(_ sender: Any) {
        ProgressHUD.show("Waiting...")
        
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        invalidInfoLabel.text = ""
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                ProgressHUD.showError("\(error.localizedDescription)")
                
                self.emailTextField.layer.borderWidth = 1.5
                self.emailTextField.layer.cornerRadius = 5
                self.emailTextField.layer.borderColor = UIColor.red.cgColor
                
                self.passwordTextField.layer.borderWidth = 1.5
                self.passwordTextField.layer.cornerRadius = 5
                self.passwordTextField.layer.borderColor = UIColor.red.cgColor
                
                self.invalidInfoLabel.text = "* Invalid email or password. Please try again."
                self.invalidInfoLabel.textColor = .red
                self.invalidInfoLabel.textAlignment = .center
                
                return
                
            } else {
                
                ProgressHUD.showSuccess("Success")
                
                if email == email && password == password {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "feedVC")
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        })
    }
    @IBOutlet weak var invalidInfoLabel: UILabel!
}
