//
//  PostsViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/15/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostsViewController: UIViewController, UITextViewDelegate {

    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        setupTextView()
//        self.automaticallyAdjustsScrollViewInsets = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setupTextView() {
        postTextView.text = "What is it now?..."
        postTextView.textColor = .lightGray
        postTextView.layer.cornerRadius = 5
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if postTextView.textColor == .lightGray {
            postTextView.text = nil
            postTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if postTextView.text.isEmpty {
            postTextView.text = "What is it now?..."
            postTextView.textColor = .lightGray
        }
    }
    
    @IBOutlet weak var postTextView: UITextView!
    @IBAction func backButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "feedVC")
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        if postTextView.text == "" {
            return
        } else {
            ProgressHUD.show("Waiting...")
            guard let text = postTextView.text else { return }
            guard let username = Auth.auth().currentUser?.displayName else { return }
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            let ref = Database.database().reference()
            let postReference = ref.child("Posts")
            let newPostID = postReference.childByAutoId().key
            let newPostReference = postReference.child(newPostID)
            newPostReference.setValue(["post": text,
                                       "username": username,
                                       "userID": userID,
                                       "hisLikes": post?.hisLikeCount ?? 0,
                                       "herLikes": post?.herLikeCount ?? 0,
                                       "timestamp": ServerValue.timestamp()], withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError("\(error!.localizedDescription)")
                }
                                        
                let myPostRef = API.MyPosts.ref_MyPosts.child(userID).child(newPostID)
                myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        ProgressHUD.showError("\(error!.localizedDescription)")
                        return
                    }
                })
                                        
                ProgressHUD.showSuccess("Success")
                self.postTextView.text = ""
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "feedVC")
        present(viewController, animated: true, completion: nil)
    }
}
