//
//  LoginViewModel.swift
//  LoginWithFirebase
//
//  Created by mac on 5/26/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

protocol LoginBaseViewModel: BaseViewModel {
    func LoginWithAccount(email: String?, password: String?) -> Void
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
    
    func LoginWithAccount(email: String?, password: String?) -> Void {
        guard let email = email,
            let password = password,
            ValidateInformation(email: email, password: password) else { return }
        
        IHProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] (user, error) in
            IHProgressHUD.dismiss()
            guard let self = self else { return }
            guard error == nil else {
                self.didError?(error!.localizedDescription)
                return
            }
            self.didChange?()
        })
        return
    }
    
    private func ValidateInformation(email: String, password: String) -> Bool {
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
