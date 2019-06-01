//
//  ViewController.swift
//  LoginWithFirebase
//
//  Created by mac on 5/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

final class MainViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var segmentControls: UISegmentedControl!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private lazy var loginViewController: LoginViewController = {
        let vc = LoginViewController.instantiate()
        add(asChildViewController: vc)
        return vc
    }()

    private lazy var registerViewController: RegisterViewController = {
        let vc = RegisterViewController.instantiate()
        add(asChildViewController: vc)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentControls.selectedSegmentIndex = 0
        updateView()
    }
    
    private func config() {
        navigationController?.navigationBar.isHidden = true
        segmentControls.addTarget(self, action: #selector(selectionDidChange), for: .valueChanged)
        IHProgressHUD.set(defaultStyle: .dark)
        IHProgressHUD.set(defaultMaskType: .black)
        hideKeyboardWhenTappedAround()
        
        registerViewController.delegate = self
        loginViewController.delegate = self
        scrollView.isScrollEnabled = false
        
        //Check if user logged in using gmail account
        if let _ = Auth.auth().currentUser {
            let vc = HomeViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        }
        
        //Check if user logged in using facebook account
        if let _ = AccessToken.current {
            //User is already logged in with facebook
            let vc = HomeViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
            print("User is already logged in")
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        let _ = viewController.then {
            $0.view.frame = containerView.bounds
            $0.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            $0.didMove(toParent: self)
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentControls.selectedSegmentIndex == 0 {
            remove(asChildViewController: registerViewController)
            add(asChildViewController: loginViewController)
        } else {
            remove(asChildViewController: loginViewController)
            add(asChildViewController: registerViewController)
        }
    }
}

extension MainViewController: KeyboardDelegation {
    @objc
    private func selectionDidChange(sender: UISegmentedControl) {
        updateView()
    }
    
    private func animateViewMoving(up: Bool) {
        let moveValue: CGFloat = 64
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        scrollView.frame = scrollView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

    func keyboardShow() {
        scrollView.isScrollEnabled = true
        animateViewMoving(up: true)
    }

    func keyboardHide() {
        scrollView.isScrollEnabled = false
        animateViewMoving(up: false)
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
