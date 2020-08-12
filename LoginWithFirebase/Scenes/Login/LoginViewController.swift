//
//  LoginViewController.swift
//  LoginWithFirebase
//
//  Created by mac on 5/23/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import GoogleSignIn

final class LoginViewController: UIViewController {
    @IBOutlet private weak var emailTextField: DesignableUITextField!
    @IBOutlet private weak var passwordTextField: DesignableUITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
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
        GIDSignIn.sharedInstance()?.presentingViewController = self
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
        viewModel.loginWithFacebook(from: self)
    }
    
    @IBAction func handleGoogleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func handleTwitterButtonTapped(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }

extension LoginViewController: GIDSignInDelegate {
    //This method will be called when a user successfully signs into your account.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            self.showError(message: error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        self.viewModel.signIntoFirebase(credential)
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
}

extension LoginViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.main
}
