//
//  LoginViewController.swift
//  LoginWithFirebase
//
//  Created by mac on 5/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextField: DesignableUITextField!
    @IBOutlet private weak var passwordTextField: DesignableUITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    weak var delegate: KeyboardDelegation?
    private var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        configGoogleSDK()
    }
    
    private func config() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        viewModel = LoginViewModel()
        
        viewModel.bind { [weak self] in
            guard let self = self else { return }
            let vc = HomeViewController.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.bindError { [weak self] errorDescription in
            guard let self = self else { return }
            self.showError(message: errorDescription)
        }
    }
    
    private func configGoogleSDK() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction private func handleLoginTapped(_ sender: Any) {
        viewModel.LoginWithAccount(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func handleFacebookButtonTapped(_ sender: Any) {
        loginViaFacebook()
    }
    
    @IBAction func handleGoogleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func handleTwitterButtonTapped(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    
    private func loginViaFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self, handler: { [weak self] result, error in
            guard let self = self else { return }
            if error != nil {
                print("The Login Process in Facebook has an error")
            } else if result?.isCancelled ?? true {
                print("The Login Process is cancelled")
            } else {
                print("User has logged in")
                let vc = HomeViewController.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    //This method will be called when a user successfully signs into your account.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // When user is signed in
        IHProgressHUD.show()
        Auth.auth().signIn(with: credential, completion: { [weak self] (user, error) in
            IHProgressHUD.dismiss()
            guard let self = self else { return }
            if let error = error {
                print("Google Authentification Fail \(error.localizedDescription)")
                return
            } else {
                print("Google Authentification Success")
                let vc = HomeViewController.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.keyboardShow()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.keyboardHide()
    }
}

extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
