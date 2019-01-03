//
//  LoginViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/21/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidInfoLabel: UILabel!
    
    let progressHUD = JGProgressHUD(style: .dark)
    let errorHUD = JGProgressHUD(style: .dark)
    let successHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Listen to see if we should keep user logged in
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if API.User.current_User != nil {
//                self.performSegue(withIdentifier: "SignInComplete", sender: self)
//            }
//        }
        
        // Check to see if the user is still logged in
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "SignInComplete", sender: self)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func signInComplete() {
        performSegue(withIdentifier: "SignInComplete", sender: self)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        invalidInfoLabel.text = ""
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        progressHUD.textLabel.text = "Loading..."
        progressHUD.show(in: self.view)
        
        UserModel.signInWith(email: email, password: password, onError: { (error) in
            self.progressHUD.dismiss()
            
            self.errorHUD.textLabel.text = "\(error)"
            self.errorHUD.tintColor = .red
            self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            self.errorHUD.show(in: self.view)
            self.errorHUD.dismiss(afterDelay: 3.0)
            
            self.emailTextField.layer.borderWidth = 1.5
            self.emailTextField.layer.cornerRadius = 5
            self.emailTextField.layer.borderColor = UIColor.red.cgColor
            
            self.passwordTextField.layer.borderWidth = 1.5
            self.passwordTextField.layer.cornerRadius = 5
            self.passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            self.invalidInfoLabel.text = "* Invalid email or password. Please try again."
            self.invalidInfoLabel.textColor = .red
            self.invalidInfoLabel.textAlignment = .center
            
        }, onSuccess: {
            self.progressHUD.dismiss()
            
            self.successHUD.textLabel.text = "Success"
            self.successHUD.tintColor = .green
            self.successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            self.successHUD.show(in: self.view)
            self.successHUD.dismiss(afterDelay: 2.0)
            
            // Put the segue in a Timer to give the successHUD view time to show
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(LoginViewController.signInComplete), userInfo: nil, repeats: false)
        })
    }
}
