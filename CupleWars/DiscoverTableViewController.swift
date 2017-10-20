//
//  DiscoverTableViewController.swift
//  CoupleWars
//
//  Created by Luis Puentes on 10/19/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DiscoverTableViewController: UITableViewController {

    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAllUsers()
    }
    
    func loadAllUsers() {
        API.User.observeUser { (user) in
            self.isFollowing(userID: user.userID!, completion: { (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func isFollowing(userID: String, completion: @escaping (Bool) -> Void) {
        API.Follow.isFollowing(userID: userID, completion: completion)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoverUsersCell", for: indexPath) as! DiscoverTableViewCell
        
        let user = users[indexPath.row]
        cell.user = user
        
        return cell
    }
}
