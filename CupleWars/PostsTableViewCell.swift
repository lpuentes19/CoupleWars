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
        
        let tapGestureForHerLikeImage = UITapGestureRecognizer(target: self, action: #selector(self.herLikeImageTapped))
        herLikeImageView.addGestureRecognizer(tapGestureForHerLikeImage)
        herLikeImageView.isUserInteractionEnabled = true
    }
    
    func setupTextView() {
        postTextView.layer.cornerRadius = 5
    }
    
    func setupUserInfo() {
        guard let user = user else { return }
        usernameLabel.text = user.username
    }
    
    func updateViews() {
        guard let post = post else { return }
        
        postTextView.text = post.postText
        dateLabel.text = post.date.toString(dateFormat: "dd-MMM-yyyy")
        updateHisLike(post: post)
        updateHerLike(post: post)
        
        // Methods below checks for changes in his and her likes and updates them in real time
        API.Post.ref_Posts.child(post.postID!).child("hisLikes").observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                self.hisCountLabel.text = "\(value) Likes"
            }
        })
        
        API.Post.ref_Posts.child(post.postID!).child("herLikes").observe(.childChanged, with: { (snapshot) in
            if let value = snapshot.value as? Int {
                self.herCountLabel.text = "\(value) Likes"
            }
        })
    }
    
    func hisLikeImageTapped() {
        postRef = API.Post.ref_Posts.child(post!.postID!)
        incrementLikesForHim(forRef: postRef)
    }
    
    func updateHisLike(post: Post) {
        let imageName = post.hisLikes == nil || !post.isLiked! ? "man" : "manFilled"
        hisLikeImageView.image = UIImage(named: imageName)
        
        guard let count = post.hisLikeCount else { return }
        if count != 0 {
            hisCountLabel.text = "\(count) Likes"
        } else if post.hisLikeCount == 0 {
            hisCountLabel.text = "0 Likes"
        }
    }
    
    func incrementLikesForHim(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var hisLikes: Dictionary<String, Bool>
                hisLikes = post["hisLikes"] as? [String : Bool] ?? [:]
                var hisLikeCount = post["hisLikeCount"] as? Int ?? 0
                if let _ = hisLikes[uid] {
                    // Unstar the post and remove self from likes
                    hisLikeCount -= 1
                    hisLikes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    hisLikeCount += 1
                    hisLikes[uid] = true
                }
                post["hisLikeCount"] = hisLikeCount as AnyObject?
                post["hisLikes"] = hisLikes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot!.key)
                self.updateHisLike(post: post)
            }
        }
    }
    
    func herLikeImageTapped() {
        postRef = API.Post.ref_Posts.child(post!.postID!)
        incrementLikesForHer(forRef: postRef)
    }
    
    func updateHerLike(post: Post) {
        let imageName = post.herLikes == nil || !post.isLiked! ? "women" : "womanFilled"
        herLikeImageView.image = UIImage(named: imageName)
        
        guard let count = post.herLikeCount else { return }
        if count != 0 {
            herCountLabel.text = "\(count) Likes"
        } else if post.herLikeCount == 0 {
            herCountLabel.text = "0 Likes"
        }
    }
    
    func incrementLikesForHer(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var herLikes: Dictionary<String, Bool>
                herLikes = post["herLikes"] as? [String : Bool] ?? [:]
                var herLikeCount = post["herLikeCount"] as? Int ?? 0
                if let _ = herLikes[uid] {
                    // Unstar the post and remove self from likes
                    herLikeCount -= 1
                    herLikes.removeValue(forKey: uid)
                } else {
                    // Like the post and add self to likes
                    herLikeCount += 1
                    herLikes[uid] = true
                }
                post["herLikeCount"] = herLikeCount as AnyObject?
                post["herLikes"] = herLikes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot!.key)
                self.updateHerLike(post: post)
            }
        }
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
