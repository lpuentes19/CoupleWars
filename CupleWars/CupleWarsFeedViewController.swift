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

class CupleWarsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostsTableViewCellDelegate {

    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        postTextField.addTarget(self, action: #selector((toPostVC)), for: UIControlEvents.editingDidBegin)
        fetchPosts()
    }
    
    func fetchPosts() {
        activityIndicator.startAnimating()
        API.Post.observePosts { (post) in
            guard let postID = post.userID else { return }
            self.fetchUser(userID: postID, completed: {
                self.posts.append(post)
//                self.posts.sort(by: {$0.date > $1.date})
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(userID: String, completed: @escaping () -> Void) {
        API.User.observeUsers(withID: userID, completion: { (user) in
            self.users.append(user)
            completed()
        })
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
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        
        cell.post = post
        cell.user = user
        cell.delegate = self

        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
