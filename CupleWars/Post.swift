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
    
    var postRef = Database.database().reference()
    
    var postText: String
    var userID: String
    var username: String
    var hisLikes: Int
    var herLikes: Int
    var date: Date = Date()
    
    var likesForHim: [String] = [String]()
    var likesForHer: [String] = [String]()
    
    init(postText: String, userID: String, username: String, hisLikes: Int, herLikes: Int) {

        self.postText = postText
        self.userID = userID
        self.username = username
        self.hisLikes = hisLikes
        self.herLikes = herLikes
    }
    
    func addSubtractHisVotes(addVote: Bool) {
        
        if addVote {
            hisLikes = hisLikes + 1
        } else {
            hisLikes = hisLikes - 1
        }
        
        postRef.child("hisLikes").setValue(hisLikes)
    }
    
    func addSubtractHerVotes(addVote: Bool) {
        
        if addVote {
            herLikes = herLikes + 1
        } else {
            herLikes = herLikes - 1
        }
        
        postRef.child("herLikes").setValue(herLikes)
    }
}
