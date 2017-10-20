//
//  DiscoverTableViewCell.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/19/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    var user: UserModel? {
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
        if user!.isFollowing! == false {
            API.Follow.followAction(withUser: user!.userID!)
            configureUnFollowButton()
            user!.isFollowing! = true
        }
        
    }
    
    func unFollowAction() {
        if user!.isFollowing! == true {
            API.Follow.unFollowAction(withUser: user!.userID!)
            configureFollowButton()
            user!.isFollowing! = false
        }
    }
    
    func configureFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 5
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        followButton.setTitleColor(.white, for: .normal)
        
        self.followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
    }
    
    func configureUnFollowButton() {
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 5
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.backgroundColor = .white
        followButton.setTitleColor(.black, for: .normal)
        
        self.followButton.setTitle("Following", for: .normal)
        followButton.addTarget(self, action: #selector(unFollowAction), for: .touchUpInside)
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
}
