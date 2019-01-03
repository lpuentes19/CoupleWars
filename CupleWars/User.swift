//
//  User.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/15/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserModel {
    
    var email: String?
    var userID: String?
    var username: String?
    var isFollowing: Bool?
}

extension UserModel {
    static func transformUser(dict: [String: Any], key: String) -> UserModel {
        let user = UserModel()
        
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.userID = key
        
        return user
    }
    
    static func signInWith(email: String, password: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
}
