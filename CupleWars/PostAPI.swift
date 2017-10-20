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
    
    func observePost(withID userID: String, completion: @escaping (Post) -> Void) {
        ref_Posts.child(userID).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observeHisLikeCount(withID postID: String, completion: @escaping (Int) -> Void) {
        ref_Posts.child(postID).child("hisLikes").observe(.childChanged, with: { snapshot in
            if let value = snapshot.value as? Int {
                completion(value)
            }
        })
    }
    
    func observeHerLikeCount(withID postID: String, completion: @escaping (Int) -> Void) {
        ref_Posts.child(postID).child("herLikes").observe(.childChanged, with: { snapshot in
            if let value = snapshot.value as? Int {
                completion(value)
            }
        })
    }
    
    func incrementLikesForHim(postID: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let postRef = API.Post.ref_Posts.child(postID)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = API.User.current_User?.uid {
                var hisLikes: Dictionary<String, Bool>
                hisLikes = post["hisLikes"] as? [String : Bool] ?? [:]
                var hisLikeCount = post["hisLikeCount"] as? Int ?? 0
                if let _ = hisLikes[uid] {
                    // Unstar the post and remove self from likes
                    hisLikeCount -= 1
                    hisLikes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    hisLikeCount += 1
                    hisLikes[uid] = true
                }
                post["hisLikeCount"] = hisLikeCount as AnyObject?
                post["hisLikes"] = hisLikes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot!.key)
                onSuccess(post)
            }
        }
    }
    
    func incrementLikesForHer(postID: String, onSuccess: @escaping (Post) -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        let postRef = API.Post.ref_Posts.child(postID)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = API.User.current_User?.uid {
                var hisLikes: Dictionary<String, Bool>
                hisLikes = post["herLikes"] as? [String : Bool] ?? [:]
                var hisLikeCount = post["herLikeCount"] as? Int ?? 0
                if let _ = hisLikes[uid] {
                    // Unstar the post and remove self from likes
                    hisLikeCount -= 1
                    hisLikes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    hisLikeCount += 1
                    hisLikes[uid] = true
                }
                post["herLikeCount"] = hisLikeCount as AnyObject?
                post["herLikes"] = hisLikes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                onError(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot!.key)
                onSuccess(post)
            }
        }
    }
}
