//
//  ForgotPasswordViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/28/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func signInButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "loginVC")
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }

    }
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "createAccountVC")
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }

    }
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
                
                let alertController = UIAlertController(title: "Email Not Found", message: "Invalid email address. Please enter a valid email address.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            print("Success")
            
            let alertController = UIAlertController(title: "Email Sent", message: "Password reset email has been successfully sent to your email address. Please reset your password and log in using the new password.", preferredStyle: .alert)
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
