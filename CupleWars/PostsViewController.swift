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
        self.automaticallyAdjustsScrollViewInsets = false
        
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
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference()
            let key = ref.child("Posts").childByAutoId().key
            
            let feed = ["userID": uid,
                        "username": post?.username ?? "",
                        "post": postTextView.text,
                        "hisLikes": post?.hisLikes ?? 0,
                        "herLikes": post?.herLikes ?? 0] as [String: Any]
            
            let postFeed = ["\(key)": feed]
            ref.child("Posts").updateChildValues(postFeed)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "feedVC")
        present(viewController, animated: true, completion: nil)
    }
}
