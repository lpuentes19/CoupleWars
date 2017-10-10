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
    var hisLikeCount: Int?
    var herLikeCount: Int?
    var hisLikes: Dictionary<String, Any>?
    var herLikes: Dictionary<String, Any>?
    var isLiked: Bool?
    var date: ServerValue?
    
}

extension Post {
    // Extracting data from Firebase (snapshot.value)
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.postID = key
//        post.date = dict["date"] as? Date
        post.postText = dict["post"] as? String
        post.userID = dict["userID"] as? String
        post.username = dict["username"] as? String
        post.hisLikeCount = dict["hisLikeCount"] as? Int ?? 0
        post.herLikeCount = dict["herLikeCount"] as? Int ?? 0
        post.hisLikes = dict["hisLikes"] as? Dictionary<String, Any>
        post.herLikes = dict["herLikes"] as? Dictionary<String, Any>
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            if post.hisLikes != nil {
                if post.hisLikes?[currentUserID] != nil {
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            if post.herLikes != nil {
                if post.herLikes?[currentUserID] != nil {
                    post.isLiked = true
                } else {
                    post.isLiked = false
                }
            }
        }
        return post
    }
}
