//
//  User.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/15/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation

class User {
    
    var email: String?
    var userID: String?
    var username: String?
    var isFollowing: Bool?
}

extension User {
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        
        user.email = dict["email"] as? String
        user.username = dict["username"] as? String
        user.userID = key
        
        return user
    }
}
