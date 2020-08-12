//
//  RegisterViewModel.swift
//  LoginWithFirebase
//
//  Created by mac on 5/27/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

protocol RegisterBaseViewModel: BaseViewModel {
    func registerWithAccount(username: String?, email: String?, password: String?) -> Void
}

final class RegisterViewModel: RegisterBaseViewModel {
    private var didChange: (() -> Void)?
    private var didError: ((String) -> Void)?
    
    func bind(didChange: @escaping () -> Void) {
        self.didChange = didChange
    }
    
    func bindError(didError: @escaping (String) -> Void) {
        self.didError = didError
    }
    
    func registerWithAccount(username: String?, email: String?, password: String?) -> Void {
        guard let username = username,
            let email = email,
            let password = password,
            validateInformation(username: username, email: email, password: password) else {
                didError!(ErrorDescription.fieldIsNil.rawValue)
                return
        }
        
        IHProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password, completion:  { [weak self] (user, error) in
            guard let self = self else { return }
            IHProgressHUD.dismiss()
            guard error == nil else {
                self.didError?(error!.localizedDescription)
                return
            }
            self.changeUsername(user,username: username)
        })
        return
    }
    
    private func changeUsername(_ user: AuthDataResult?, username: String) {
        guard let user = user else {
            return
        }
        IHProgressHUD.show()
        let request = user.user.createProfileChangeRequest()
        request.displayName = username
        request.commitChanges(completion:  { [weak self] (error) in
            IHProgressHUD.dismiss()
            guard let self = self else { return }
            guard error == nil else {
                self.didError?(error!.localizedDescription)
                return
            }
            self.didChange?()
        })
    }
    
    private func validateInformation(username: String, email: String, password: String) -> Bool {
        guard username != "", email != "", password != ""
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

