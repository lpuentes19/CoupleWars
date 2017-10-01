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
    
    var post: Post?
    var postLikeRef = Database.database().reference().child("Posts")
    var pID: String?
    // var isLiked = false
    var delegate: PostsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextView()
    }
    
    func setupTextView() {
        postTextView.layer.cornerRadius = 5
    }
    
    func configureCell(post: Post) {
        self.post = post
        
        usernameLabel.text = post.username
        postTextView.text = post.postText
        dateLabel.text = post.date.stringValue()
        
        if post.hisLikes == 1 {
            hisCountLabel.text = "\(post.hisLikes) Like(s)"
        } else {
            hisCountLabel.text = "\(post.hisLikes) Likes"
        }
        
        if post.herLikes == 1 {
            herCountLabel.text = "\(post.herLikes) Like(s)"
        } else {
            herCountLabel.text = "\(post.herLikes) Likes"
        }
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
       
//        hisUnlikeButton.isEnabled = false
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
//                            self.hisLikeButton.isHidden = false
//                            self.hisUnlikeButton.isHidden = true
//                            self.hisUnlikeButton.isEnabled = true
                            break
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    @IBAction func herUnlikeButtonTapped(_ sender: Any) {
       
        herUnlikeButton.isEnabled = false
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
//                            self.herLikeButton.isHidden = false
//                            self.herUnlikeButton.isHidden = true
//                            self.herUnlikeButton.isEnabled = true
                            break
                        }
                    }
                }
            }
        })
        ref.removeAllObservers()
    }
    
    @IBAction func himButtonTapped(_ sender: Any) {
//        guard let post = post else { return }
//
//        postLikeRef.child("hisLikes").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let thumbsUpDown = snapshot.value as? Int {
//                print(thumbsUpDown)
//
//                post.addSubtractHisVotes(addVote: true)
//                self.postLikeRef.setValue(true)
//            } else {
//                post.addSubtractHisVotes(addVote: false)
//                self.postLikeRef.removeValue()
//            }
//        })
//    }
        
        

//        hisLikeButton.isEnabled = false
            let ref = Database.database().reference()
            let keyToPost = ref.child("Posts").childByAutoId().key

            guard let postID = pID else { return }

            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? [String: AnyObject] {
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
                                        
//                                        self.hisLikeButton.isHidden = true
//                                        self.hisUnlikeButton.isHidden = false
//                                        self.hisLikeButton.isEnabled = true
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
        
//        guard let post = post else { return }
//
//        postLikeRef.child("Posts").child("herLikes").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let thumbsUpDown = snapshot.value as? Int {
//                print(thumbsUpDown)
//
//                post.addSubtractHerVotes(addVote: true)
//                self.postLikeRef.setValue(true)
//            } else {
//                post.addSubtractHerVotes(addVote: false)
//                self.postLikeRef.removeValue()
//            }
//        })
//    }
//        herLikeButton.isEnabled = false
            let ref = Database.database().reference()
            let keyToPost = ref.child("Posts").childByAutoId().key

            guard let postID = pID else { return }

            ref.child("Posts").child(postID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? [String: AnyObject] {
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
                                        
//                                        self.herLikeButton.isHidden = true
//                                        self.herUnlikeButton.isHidden = false
//                                        self.herLikeButton.isEnabled = true
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

protocol PostsTableViewCellDelegate {

}
