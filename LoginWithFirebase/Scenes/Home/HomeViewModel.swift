//
//  HomeViewModel.swift
//  LoginWithFirebase
//
//  Created by Nguyen Duc Huy B on 7/27/20.
//  Copyright © 2020 sunasterisk. All rights reserved.
//

protocol HomeBaseViewModel: BaseViewModel {
    func linkToAccount(_ credential: AuthCredential)
}

final class HomeViewModel: HomeBaseViewModel {
    
    private var didChange: (() -> Void)?
    private var didError: ((String) -> Void)?
    
    func bind(didChange: @escaping () -> Void) {
        self.didChange = didChange
    }
    
    func bindError(didError: @escaping (String) -> Void) {
        self.didError = didError
    }
    
    // Link Authentication Providers
    func linkToAccount(_ credential: AuthCredential) {
        Auth.auth().currentUser?.link(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            } else {
                print("link auth provider credentials to user account successfully")
            }
        }
    }
}
