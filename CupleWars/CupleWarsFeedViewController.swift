//
//  CupleWarsFeedViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/11/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CupleWarsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        postTextField.addTarget(self, action: #selector((toPostVC)), for: UIControlEvents.editingDidBegin)
        
        fetchPosts()
    }
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
        
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postsSnap = snapshot.value as? [String: Any]
            
            let post = Post()
            
            if let text = postsSnap?["post"] as? String, let postID = postsSnap?["postID"] as? String, let userID = postsSnap?["userID"] as? String, let username = postsSnap?["username"] as? String {
                
                post.post = text
                post.postID = postID
                post.userID = userID
                post.username = username
                
                self.posts.append(post)
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
    }
    
    func toPostVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "postVC")
        present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostsTableViewCell
        
        cell.usernameLabel.text = posts[indexPath.row].username
        cell.postTextView.text = posts[indexPath.row].post
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
}
