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
    
    func reportPosts(postID: String) {
        
        ref_ReportPost.setValue(["\(API.User.current_User!.uid)": "\(postID)"], withCompletionBlock: { (error, ref) in
            if error != nil {
                ProgressHUD.showError("\(error!.localizedDescription)")
            }
        })
    }
}
