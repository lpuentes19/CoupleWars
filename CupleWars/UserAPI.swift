//
//  UserAPI.swift
//  CupleWars
//
//  Created by Luis Puentes on 10/6/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class UserAPI {
    var ref_Users = Database.database().reference().child("Users")
    
    var ref_Current_User: DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else { return nil}
        
        return ref_Users.child(currentUser.uid)
    }
    
    var current_User: User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    func observeUsers(withID userID: String, completion: @escaping (UserModel) -> Void) {
        ref_Users.child(userID).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUser(completion: @escaping (UserModel) -> Void) {
        ref_Users.observe(.childAdded, with:
            { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let user = UserModel.transformUser(dict: dict, key: snapshot.key)
                    completion(user)
                }
        })
    }
}
