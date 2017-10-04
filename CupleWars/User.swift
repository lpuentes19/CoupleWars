//
//  User.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/15/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation

class User {
    
    var userID: String?
    var username: String?
}

extension User {
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        
        user.userID = dict["userID"] as? String
        user.username = dict["username"] as? String
        
        return user
    }
}
