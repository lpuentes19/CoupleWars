//
//  FollowAPI.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/19/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FollowAPI {
    
    var ref_Followers = Database.database().reference().child("Followers")
    var ref_Following = Database.database().reference().child("Following")
    
    func followAction(withUser id: String) {
        ref_Followers.child(id).child(Auth.auth().currentUser!.uid).setValue(true)
        ref_Following.child(Auth.auth().currentUser!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String) {
        ref_Followers.child(id).child(Auth.auth().currentUser!.uid).setValue(NSNull())
        ref_Following.child(Auth.auth().currentUser!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userID: String, completion: @escaping (Bool) -> Void) {
        ref_Followers.child(userID).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completion(false)
            } else {
                completion(true)
            }
            
        })
    }
}
