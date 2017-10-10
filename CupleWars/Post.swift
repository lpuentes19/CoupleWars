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
    
    var postID: String?
    var postText: String?
    var userID: String?
    var username: String?
    var hisLikes: Int?
    var herLikes: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
    var date: Date = Date()
}

extension Post {
    // Extracting data from Firebase (snapshot.value)
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.postID = key
        post.postText = dict["post"] as? String
        post.userID = dict["userID"] as? String
        post.username = dict["username"] as? String
        post.hisLikes = dict["hisLikes"] as? Int ?? 0
        post.herLikes = dict["herLikes"] as? Int ?? 0
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUserID = Auth.auth().currentUser?.uid {
            if post.likes != nil {
                if post.likes?[currentUserID] != nil {
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }
        return post
    }
}
