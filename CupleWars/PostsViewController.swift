//
//  PostsViewController.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/15/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        
        setupTextView()
    }
    
    func setupTextView() {
        postTextView.text = "What is it now?..."
        postTextView.textColor = .lightGray
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var postTextView: UITextView!
    @IBAction func postButtonTapped(_ sender: Any) {
    }
}
