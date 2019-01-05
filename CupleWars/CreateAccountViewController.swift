//
//  CreateAccountViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/22/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidInfoLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var licensingSwitch: UISwitch!
    
    var ref = Database.database().reference()
    
    let progressHUD = JGProgressHUD(style: .dark)
    let errorHUD = JGProgressHUD(style: .dark)
    let successHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwitch()
        
        createAccountButton.isEnabled = false
        createAccountButton.backgroundColor = .black
        createAccountButton.setTitleColor(.lightGray , for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupSwitch() {
        licensingSwitch.isOn = false
        licensingSwitch.onTintColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    }
    
    @objc func signUpComplete() {
        performSegue(withIdentifier: "SignUpComplete", sender: self)
    }
    
    @IBAction func licensingSwitchTouched(_ sender: Any) {
        
        if licensingSwitch.isOn {
            licensingSwitch.isOn = false
            createAccountButton.isEnabled = false
            createAccountButton.backgroundColor = .black
            createAccountButton.setTitleColor(.lightGray , for: .normal)
        } else {
            licensingSwitch.isOn = true
            createAccountButton.isEnabled = true
            createAccountButton.backgroundColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
            createAccountButton.setTitleColor(.white , for: .normal)
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        usernameTextField.layer.borderWidth = 0
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        
        guard let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        if password.count < 6 {
            passwordTextField.layer.borderWidth = 1.5
            passwordTextField.layer.cornerRadius = 5
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            
            invalidInfoLabel.text = "* Password must contain at least 6 characters or more."
            invalidInfoLabel.textColor = .red
            
            return
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
            
            progressHUD.textLabel.text = "Loading..."
            progressHUD.show(in: self.view)
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    self.progressHUD.dismiss()
                    
                    self.errorHUD.textLabel.text = "\(error!.localizedDescription)"
                    self.errorHUD.tintColor = .red
                    self.errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.errorHUD.show(in: self.view)
                    self.errorHUD.dismiss(afterDelay: 3.0)
                    
                    return
                }
                
                if let user = user {
                    
                    guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { return }
                    changeRequest.displayName = username
                    changeRequest.commitChanges(completion: nil)
                    
                    let userInfo: [String: Any] = ["email": email,
                                                   "uid": user.uid,
                                                   "username": username]
                    
                    self.ref.child("Users").child(user.uid).setValue(userInfo)
                    
                    self.progressHUD.dismiss()
                    
                    self.successHUD.textLabel.text = "Success"
                    self.successHUD.tintColor = .green
                    self.successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.successHUD.show(in: self.view)
                    self.successHUD.dismiss(afterDelay: 2.0)
                    
                    // Put the segue in a Timer to give the successHUD view time to show
                    Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(CreateAccountViewController.signUpComplete), userInfo: nil, repeats: false)
                }
            })
        }
    }
}
