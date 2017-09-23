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
        
        ref.child("Posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                let text = dict["post"] as! String
                let postID = dict["postID"] as! String
                let userID = dict["userID"] as! String
                let username = dict["username"] as! String
                
                let post = Post(post: text, userID: userID, username: username, postID: postID)
                
                self.posts.append(post)
                self.tableView.reloadData()
            }
        }
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
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginVC")
        present(vc, animated: true, completion: nil)
    }
}
