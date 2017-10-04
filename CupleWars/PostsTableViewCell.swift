//
//  PostsTableViewCell.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/15/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PostsTableViewCell: UITableViewCell {
    
    var delegate: PostsTableViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    func setupTextView() {
        postTextView.layer.cornerRadius = 5
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        usernameLabel.text = post.username
        postTextView.text = post.postText
        dateLabel.text = post.date.toString(dateFormat: "dd-MMM-yyyy")
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var himButton: UIButton!
    @IBOutlet weak var herButton: UIButton!
    @IBOutlet weak var hisCountLabel: UILabel!
    @IBOutlet weak var herCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hisLikeButton: UIButton!
    @IBOutlet weak var herLikeButton: UIButton!
    @IBOutlet weak var hisUnlikeButton: UIButton!
    @IBOutlet weak var herUnlikeButton: UIButton!
    
    @IBAction func hisUnlikeButtonTapped(_ sender: Any) {
       
    }
    
    @IBAction func herUnlikeButtonTapped(_ sender: Any) {
       
    }
    
    @IBAction func himButtonTapped(_ sender: Any) {

    }
    
    @IBAction func herButtonTapped(_ sender: Any) {
        
    }
}

protocol PostsTableViewCellDelegate {
}
