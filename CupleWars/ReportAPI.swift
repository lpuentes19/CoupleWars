//
//  ReportAPI.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/23/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class ReportAPI {

    let ref_ReportPost = Database.database().reference().child("ReportedPosts")
    
    func observeReports(user: String, postID: String) {
        API.Feed.ref_Feed.child(user).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String: Any] {
                self.ref_ReportPost.child(postID).setValue(["\(API.User.current_User!.uid)": "\(postID)"])
            }
        })
    }
}
