//
//  LoginViewModel.swift
//  LoginWithFirebase
//
//  Created by mac on 5/26/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

protocol LoginBaseViewModel: BaseViewModel {
    func LoginWithAccount(email: String?, password: String?)
    func loginWithFacebook(from vc: UIViewController)
    func signIntoFirebase(_ credential: AuthCredential)
}

final class LoginViewModel: LoginBaseViewModel {
    private var didChange: (() -> Void)?
    private var didError: ((String) -> Void)?
    
    func bind(didChange: @escaping () -> Void) {
        self.didChange = didChange
    }
    
    func bindError(didError: @escaping (String) -> Void) {
        self.didError = didError
    }
    
    func LoginWithAccount(email: String?, password: String?) {
        guard let email = email,
            let password = password,
            validateInformation(email: email, password: password) else { return }
        
        IHProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            IHProgressHUD.dismiss()
            guard let self = self else { return }
            if error != nil {
                self.didError?(error!.localizedDescription)
                return
            }
            self.didChange?()
        })
        return
    }
    
    func loginWithFacebook(from vc: UIViewController) {
      let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: vc) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(granted: _, declined: _,let token):
                print("User has logged in")
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self.signIntoFirebase(credential)
            case .failed(let error):
                print("Login failed: \(error.localizedDescription)")
                self.didError?(error.localizedDescription)
            case .cancelled:
                print("Login proccess is cancelled")
            }
        }
    }
    
    func signIntoFirebase(_ credential: AuthCredential) {
        IHProgressHUD.show()
        Auth.auth().signIn(with: credential) { [weak self] _, err in
            IHProgressHUD.dismiss()
            guard let self = self else { return }
            if let err = err {
                print("Sign up error: \(err.localizedDescription)")
                self.didError?(err.localizedDescription)
                return
            }
            print("successfully authenticated with Firebase")
            self.didChange?()
        }
    }
    
    func validateInformation(email: String, password: String) -> Bool {
        guard email != "", password != ""
            else {
                didError?(ErrorDescription.fieldIsNil.rawValue)
                return false
        }
        
        guard validateEmail(candidate: email) else {
            didError?(ErrorDescription.emailIsInvalid.rawValue)
            return false
        }
        
        guard validatePassword(candidate: password) else {
            didError?(ErrorDescription.passwordIsInvalid.rawValue)
            return false
        }
        
        return true
    }
}
