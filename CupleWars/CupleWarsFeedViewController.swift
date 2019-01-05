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
import JGProgressHUD

class CupleWarsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostsTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var noPostsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [UserModel]()
    
    let progressHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        postTextField.addTarget(self, action: #selector((toPostVC)), for: UIControlEvents.editingDidBegin)
        
        fetchPosts()
    }
    
    func fetchPosts() {
        activityIndicator.startAnimating()
        API.Feed.observeFeed(withUserID: API.User.current_User!.uid) { (post) in
            guard let postID = post.userID else { return }
            
            self.fetchUser(userID: postID, completed: {
                self.posts.append(post)
                self.posts.reverse()
                Database.database().reference().queryOrdered(byChild: "date")
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
        }
        
        API.Feed.observeFeedRemoved(withUserID: API.User.current_User!.uid) { (key) in
            self.posts = self.posts.filter{ $0.postID != key }
            self.tableView.reloadData()
        }
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(stopActivityIndicator), userInfo: nil, repeats: false)
    }
    
    func fetchUser(userID: String, completed: @escaping () -> Void) {
        API.User.observeUsers(withID: userID, completion: { (user) in
            self.users.append(user)
            self.users.reverse()
            completed()
        })
    }
    
    @objc func toPostVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "postVC")
        present(viewController, animated: true, completion: nil)
    }
    
    func toProfileVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "profileVC")
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(presentNoPostsMessage), userInfo: nil, repeats: false)
    }
    
    @objc func presentNoPostsMessage() {
        if posts.count < 1 {
            progressHUD.textLabel.text = "There are no posts at the moment. \nPost something yourself and/or make sure you're following other users."
            progressHUD.tintColor = .white
            progressHUD.indicatorView = nil
            progressHUD.show(in: self.view)
            progressHUD.dismiss(afterDelay: 7)
        }
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
//        checkForPosts()
        
        return cell
    }
    
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
