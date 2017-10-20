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
    }
    
    func updateView() {
        usernameLabel.text = user?.username
        
        if user!.isFollowing! == true {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    func followAction() {
        API.Follow.followAction(withUser: user!.userID!)
        configureUnFollowButton()
    }
    
    func unFollowAction() {
        API.Follow.unFollowAction(withUser: user!.userID!)
        configureFollowButton()
    }
    
    func configureFollowButton() {
        self.followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
    }
    
    func configureUnFollowButton() {
        self.followButton.setTitle("Following", for: .normal)
        followButton.addTarget(self, action: #selector(unFollowAction), for: .touchUpInside)
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
}
