//
//  DiscoverTableViewCell.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/19/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth

class DiscoverTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        followButton.addTarget(self, action: #selector(unFollowAction), for: .touchUpInside)
    }
    
    func followAction() {
        API.Follow.followAction(withUser: user!.userID!)
    }
    
    func unFollowAction() {
        API.Follow.unFollowAction(withUser: user!.userID!)
    }
    
    func updateView() {
        usernameLabel.text = user?.username
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
}
