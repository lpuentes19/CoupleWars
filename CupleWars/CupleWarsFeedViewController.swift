//
//  CupleWarsFeedViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/11/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit

class CupleWarsFeedViewController: UIViewController { //UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.delegate = self
//        tableView.dataSource = self
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return nil
//    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
}
