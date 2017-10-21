//
//  FeedAPI.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/20/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FeedAPI {
    
    var ref_Feed = Database.database().reference().child("Feed")
    
    func observeFeed(withUserID id: String, completion: @escaping (Post) -> Void) {
        ref_Feed.child(id).observe(.childAdded, with: { (snapshot) in
            let key = snapshot.key
            API.Post.observePost(withID: key, completion: { (post) in
                completion(post)
            })
        })
    }
    
    func observeFeedRemoved(withUserID id: String, completion: @escaping (String) -> Void) {
        ref_Feed.child(id).observe(.childRemoved, with: { (snapshot) in
            let key = snapshot.key
            completion(key)
        })
    }
}
