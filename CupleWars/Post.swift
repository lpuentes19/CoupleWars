//
//  Post.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/22/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation

class Post {
    
    var post: String
    var userID: String
    var username: String
    var postID: String
    
    init(post: String, userID: String, username: String, postID: String) {
        
        self.post = post
        self.userID = userID
        self.username = username
        self.postID = postID
    }
}
