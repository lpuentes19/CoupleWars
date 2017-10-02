//
//  AppDelegate.swift
//  CupleWars
//
//  Created by Luis Puentes on 8/18/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "feedVC")
                self.window?.rootViewController = viewController
                
            } else {
                print("User must sign in")
            }
        }
        return true
    }
}

