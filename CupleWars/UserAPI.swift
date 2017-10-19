//
//  UserAPI.swift
//  CupleWars
//
//  Created by Luis Puentes on 10/6/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserAPI {
    var ref_Users = Database.database().reference().child("Users")
    
    func observeUsers(withID userID: String, completion: @escaping (User) -> Void) {
        ref_Users.child(userID).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    func observeUser(completion: @escaping (User) -> Void) {
        ref_Users.observe(.childAdded, with:
            { snapshot in
                if let dict = snapshot.value as? [String: Any] {
                    let user = User.transformUser(dict: dict, key: snapshot.key)
                    completion(user)
                }
        })
    }
}
