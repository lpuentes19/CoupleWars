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

            if let dictionary = snapshot.value as? [String: AnyObject] {

                let text = dictionary["post"] as! String
                let userID = dictionary["userID"] as! String
                let username = dictionary["username"] as! String
                let hisLikes = dictionary["hisLikes"] as? Int ?? 0
                let herLikes = dictionary["herLikes"] as? Int ?? 0

                let post = Post(postText: text, userID: userID, username: username, hisLikes: hisLikes, herLikes: herLikes)

//                if let people = dict["likesForHim"] as? [String : AnyObject] {
//                   for (_, person) in people {
//                        post.likesForHim.append(person as! String)
//                    }
//                }
//
//                if let person = dict["likesForHer"] as? [String : AnyObject] {
//                    for (_, people) in person {
//                        post.likesForHer.append(people as! String)
//                    }
//                }

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
        let post = posts[indexPath.row]
//        cell.usernameLabel.text = posts[indexPath.row].username
//        cell.postTextView.text = posts[indexPath.row].postText
        
        cell.delegate = self
        cell.configureCell(post: post)
        
        if posts[indexPath.row].hisLikes == 1 {
            cell.hisCountLabel.text = "\(posts[indexPath.row].hisLikes) Like(s)"
        } else {
            cell.hisCountLabel.text = "\(posts[indexPath.row].hisLikes) Likes"
        }
        
        if posts[indexPath.row].herLikes == 1 {
            cell.herCountLabel.text = "\(posts[indexPath.row].herLikes) Like(s)"
        } else {
            cell.herCountLabel.text = "\(posts[indexPath.row].herLikes) Likes"
        }
        
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
