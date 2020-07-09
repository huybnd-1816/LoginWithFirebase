//
//  HomeViewController.swift
//  LoginWithFirebase
//
//  Created by mac on 5/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleSignOutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error: ", error.localizedDescription)
        }
    }
}

extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
