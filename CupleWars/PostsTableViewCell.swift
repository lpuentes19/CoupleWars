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
    var postRef: DatabaseReference!
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
        
        let tapGestureForHisLikeImage = UITapGestureRecognizer(target: self, action: #selector(self.hisLikeImageTapped))
        hisLikeImageView.addGestureRecognizer(tapGestureForHisLikeImage)
        hisLikeImageView.isUserInteractionEnabled = true
    }
    
    func setupTextView() {
        postTextView.layer.cornerRadius = 5
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        postTextView.text = post.postText
        dateLabel.text = post.date.toString(dateFormat: "dd-MMM-yyyy")
        
        if let currentUser = Auth.auth().currentUser {
            API.User.ref_Users.child(currentUser.uid).child("likes").child(post.postID!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.hisLikeImageView.image = UIImage(named: "man")
                } else {
                    self.hisLikeImageView.image = UIImage(named: "manFilled")
                }
            })
        }
    }
    
    func hisLikeImageTapped() {
        
        postRef = API.Post.ref_Posts.child(post!.postID!)
        incrementLikes(forRef: postRef)
        
//        if let currentUser = Auth.auth().currentUser {
//            API.User.ref_Users.child(currentUser.uid).child("likes").child(post!.postID!).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let _ = snapshot.value as? NSNull {
//                    API.User.ref_Users.child(currentUser.uid).child("likes").child(self.post!.postID!).setValue(true)
//                    self.hisLikeImageView.image = UIImage(named: "man")
//                } else {
//                    API.User.ref_Users.child(currentUser.uid).child("likes").child(self.post!.postID!).removeValue()
//                    self.hisLikeImageView.image = UIImage(named: "manFilled")
//                }
//            })
//        }
    }
    
    func incrementLikes(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var stars: Dictionary<String, Bool>
                stars = post["stars"] as? [String : Bool] ?? [:]
                var starCount = post["starCount"] as? Int ?? 0
                if let _ = stars[uid] {
                    // Unstar the post and remove self from stars
                    starCount -= 1
                    stars.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    starCount += 1
                    stars[uid] = true
                }
                post["starCount"] = starCount as AnyObject?
                post["stars"] = stars as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func setupUserInfo() {
        guard let user = user else { return }
        
        usernameLabel.text = user.username
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var hisCountLabel: UILabel!
    @IBOutlet weak var herCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hisLikeImageView: UIImageView!
    @IBOutlet weak var herLikeImageView: UIImageView!
    
}

protocol PostsTableViewCellDelegate {
}
