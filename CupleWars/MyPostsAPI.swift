//
//  MyPostsAPI.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/20/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsAPI {
    
    var ref_MyPosts = Database.database().reference().child("MyPosts")
}
