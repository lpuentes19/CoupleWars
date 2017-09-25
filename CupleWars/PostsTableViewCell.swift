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

class PostsTableViewCell: UITableViewCell {
    
    var pID: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextView()
    }
    
    func setupTextView() {
        postTextView.layer.cornerRadius = 5
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var himButton: UIButton!
    @IBOutlet weak var herButton: UIButton!
    @IBOutlet weak var hisCountLabel: UILabel!
    @IBOutlet weak var herCountLabel: UILabel!
    
    @IBAction func himButtonTapped(_ sender: Any) {
        
        let ref = Database.database().reference()
        let keyToPost = ref.child("Posts").childByAutoId().key
        
        guard let postID = pID else { return }
        
        ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject] {
                let updateLikes: [String: Any] = ["hisPeopleLikes/\(keyToPost)" : Auth.auth().currentUser?.uid]
                ref.child("Posts").child(postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                            
                            if let properties = snap.value as? [String: AnyObject] {
                                if let likes = properties["hisPeopleLikes"] as? [String: AnyObject] {
                                    let count = likes.count
                                    self.hisCountLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes": count]
                                    ref.child("Posts").child(postID).updateChildValues(update)
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
    }
    
    @IBAction func herButtonTapped(_ sender: Any) {
        
        let ref = Database.database().reference()
        let keyToPost = ref.child("Posts").childByAutoId().key
        
        guard let postID = pID else { return }
        
        ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let post = snapshot.value as? [String: AnyObject] {
                let updateLikes: [String: Any] = ["herPeopleLikes/\(keyToPost)" : Auth.auth().currentUser?.uid]
                ref.child("Posts").child(postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                            
                            if let properties = snap.value as? [String: AnyObject] {
                                if let likes = properties["herPeopleLikes"] as? [String: AnyObject] {
                                    let count = likes.count
                                    self.herCountLabel.text = "\(count) Likes"
                                    
                                    let update = ["likes": count]
                                    ref.child("Posts").child(postID).updateChildValues(update)
                                }
                            }
                        })
                    }
                })
            }
        })
        ref.removeAllObservers()
    }
}
