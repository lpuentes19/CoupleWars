//
//  CreateUser.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/13/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class CreateUser {
    
    var userStorage: StorageReference
    var reference: DatabaseReference
    
    init(userStorage: StorageReference, reference: DatabaseReference) {
        
        self.userStorage = userStorage
        self.reference = reference
    }
}
