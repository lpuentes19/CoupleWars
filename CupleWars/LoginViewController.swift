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

    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if email == email && password == password {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "feedVC")
                    DispatchQueue.main.async {
                        self.present(viewController, animated: true, completion: nil)
                    }
                }
            }
            print("Success")
        })
    }
}
