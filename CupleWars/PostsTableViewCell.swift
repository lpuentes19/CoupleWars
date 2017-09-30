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
    var isLiked = false
    
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
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func himButtonTapped(_ sender: Any) {
//        guard let user = Auth.auth().currentUser?.uid else { return }
//        guard let postID = pID else { return }
//        let ref = Database.database().reference()
        
        if isLiked == false {
            
            isLiked = true
            let ref = Database.database().reference()
            let keyToPost = ref.child("Posts").childByAutoId().key
            
            guard let postID = pID else { return }
            
            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let post = snapshot.value as? [String: AnyObject] {
                    let updateLikes: [String: Any] = ["likesForHim/\(keyToPost)" : Auth.auth().currentUser?.uid]
                    ref.child("Posts").child(postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        if error == nil {
                            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                                
                                if let properties = snap.value as? [String: AnyObject] {
                                    if let likes = properties["likesForHim"] as? [String: AnyObject] {
                                        let count = likes.count
                                        if count <= 1 {
                                            self.hisCountLabel.text = "\(count) Like(s)"
                                        } else {
                                            self.hisCountLabel.text = "\(count) Likes"
                                        }
                                        
                                        let update = ["hisLikes": count]
                                        ref.child("Posts").child(postID).updateChildValues(update)
                                    }
                                }
                            })
                        }
                    })
                }
            })
            ref.removeAllObservers()
            
        } else {
            
            isLiked = false
            let ref = Database.database().reference()
            guard let postID = pID else { return }
            
            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let properties = snapshot.value as? [String : Any] {
                    if let peopleWhoLike = properties["likesForHim"] as? [String : AnyObject] {
                        for (id, person) in peopleWhoLike {
                            if person as? String == Auth.auth().currentUser?.uid {
                                ref.child("Posts").child(postID).child("likesForHim").child(id).removeValue(completionBlock: { (error, reff) in
                                    
                                    if error == nil {
                                        
                                        ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                                            if let prop = snap.value as? [String : AnyObject] {
                                                if let likes = prop["likesForHim"] as? [String : AnyObject] {
                                                    let count = likes.count
                                                    if count <= 1 {
                                                       self.hisCountLabel.text = "\(count) Like(s)"
                                                    } else {
                                                       self.hisCountLabel.text = "\(count) Likes"
                                                    }
                                                    
                                                    ref.child("Posts").child(postID).updateChildValues(["hisLikes" : count])
                                                } else {
                                                    self.hisCountLabel.text = "0 Likes"
                                                    ref.child("Posts").child(postID).child("hisLikes").removeValue()
                                                }
                                            }
                                        })
                                    }
                                })
                                break
                            }
                        }
                    }
                }
            })
            ref.removeAllObservers()
        }
    }
    
    @IBAction func herButtonTapped(_ sender: Any) {
        
        if isLiked == false {
            
            isLiked = true
            let ref = Database.database().reference()
            let keyToPost = ref.child("Posts").childByAutoId().key
            
            guard let postID = pID else { return }
            
            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let post = snapshot.value as? [String: AnyObject] {
                    let updateLikes: [String: Any] = ["likesForHer/\(keyToPost)" : Auth.auth().currentUser?.uid]
                    ref.child("Posts").child(postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        if error == nil {
                            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                                
                                if let properties = snap.value as? [String: AnyObject] {
                                    if let likes = properties["likesForHer"] as? [String: AnyObject] {
                                        let count = likes.count
                                        if count <= 1 {
                                            self.herCountLabel.text = "\(count) Like(s)"
                                        } else {
                                            self.herCountLabel.text = "\(count) Likes"
                                        }
                                        let update = ["herLikes": count]
                                        ref.child("Posts").child(postID).updateChildValues(update)
                                    }
                                }
                            })
                        }
                    })
                }
            })
            ref.removeAllObservers()
            
        } else {
            
            isLiked = false
            let ref = Database.database().reference()
            guard let postID = pID else { return }
            
            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let properties = snapshot.value as? [String : Any] {
                    if let peopleWhoLike = properties["likesForHer"] as? [String : AnyObject] {
                        for (id, person) in peopleWhoLike {
                            if person as? String == Auth.auth().currentUser?.uid {
                                ref.child("Posts").child(postID).child("likesForHer").child(id).removeValue(completionBlock: { (error, reff) in
                                    
                                    if error == nil {
                                        
                                        ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snap) in
                                            if let prop = snap.value as? [String : AnyObject] {
                                                if let likes = prop["likesForHer"] as? [String : AnyObject] {
                                                    let count = likes.count
                                                    if count <= 1 {
                                                        self.herCountLabel.text = "\(count) Like(s)"
                                                    } else {
                                                        self.herCountLabel.text = "\(count) Likes"
                                                    }
                                                    ref.child("Posts").child(postID).updateChildValues(["herLikes" : count])
                                                } else {
                                                    self.herCountLabel.text = "0 Likes"
                                                    ref.child("Posts").child(postID).child("herLikes").removeValue()
                                                }
                                            }
                                        })
                                    }
                                })
                                break
                            }
                        }
                    }
                }
            })
            ref.removeAllObservers()
        }
    }
}
