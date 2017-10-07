//
//  PostAPI.swift
//  CupleWars
//
//  Created by Luis Puentes on 10/6/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostAPI {
    var ref_Posts = Database.database().reference().child("Posts")
    
    func observePosts(completion: @escaping (Post) -> Void) {
        ref_Posts.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
}
