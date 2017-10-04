//
//  Post.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/22/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Post {
        
    var postText: String?
    var userID: String?
    var username: String?
    var hisLikes: Int?
    var herLikes: Int?
    var date: NSDate = NSDate()
}

extension Post {
    // Extracting data from Firebase (snapshot.value)
    static func transformPost(dict: [String: Any]) -> Post {
        let post = Post()
        
        post.postText = dict["post"] as? String
        post.userID = dict["userID"] as? String
        post.username = dict["username"] as? String
        post.hisLikes = dict["hisLikes"] as? Int ?? 0
        post.herLikes = dict["herLikes"] as? Int ?? 0
        
        return post
    }
}
