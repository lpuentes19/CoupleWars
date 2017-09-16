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

    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        postTextField.addTarget(self, action: #selector((toPostVC)), for: UIControlEvents.editingDidBegin)
    }
    
//    func retrieveUsers() {
//        
//        let ref = Database.database().reference()
//        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let users = snapshot.value as! [String: AnyObject]
//            self.user.removeAll()
//            for (_, value) in users {
//                if let uid = value["uid"] as? String {
//                    if uid != Auth.auth().currentUser?.uid {
//                        let userToShow = User()
//                        if let username = value["username"] as? String {
//                            userToShow.userID = uid
//                            userToShow.username = username
//                            self.user.append(userToShow)
//                        }
//                    }
//                }
//            }
//            self.tableView.reloadData()
//        })
//        ref.removeAllObservers()
//    }
    
    func toPostVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "postVC")
        present(viewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostsTableViewCell
        
        
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
}
