//
//  RegisterViewModel.swift
//  LoginWithFirebase
//
//  Created by mac on 5/27/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

protocol RegisterBaseViewModel: BaseViewModel {
    func RegisterWithAccount(username: String?, email: String?, password: String?) -> Void
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
    
    func RegisterWithAccount(username: String?, email: String?, password: String?) -> Void {
        guard let username = username,
            let email = email,
            let password = password,
            ValidateInformation(username: username, email: email, password: password) else {
                didError!(ErrorDescription.fieldIsNil.rawValue)
                return
        }
        
        IHProgressHUD.show()
        Auth.auth().createUser(withEmail: email, password: password, completion:  { [weak self] (user, error) in
            guard let self = self else { return }
            guard error == nil else {
                IHProgressHUD.dismiss()
                self.didError?(error!.localizedDescription)
                return
            }
            
            guard let user = user else {
                IHProgressHUD.dismiss()
                return
            }
            let changeRequest = user.user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion:  { [weak self] (error) in
                IHProgressHUD.dismiss()
                guard let self = self else { return }
                guard error == nil else {
                    self.didError?(error!.localizedDescription)
                    return
                }
                self.didChange?()
            })
        })
        return
    }
    
    private func ValidateInformation(username: String, email: String, password: String) -> Bool {
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

