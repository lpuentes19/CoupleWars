//
//  CupleWarsFeedViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/11/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit

class CupleWarsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
}
