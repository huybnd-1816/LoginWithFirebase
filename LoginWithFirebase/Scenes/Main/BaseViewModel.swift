//
//  File.swift
//  LoginWithFirebase
//
//  Created by mac on 5/27/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

protocol BaseViewModel: AnyObject {
    func bind(didChange: @escaping () -> Void)
    func bindError(didError: @escaping (String) -> Void)
    func validateEmail(candidate: String) -> Bool
    func validatePassword(candidate: String) -> Bool
}

extension BaseViewModel {
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = Regex.email.rawValue
        return NSPredicate(format: Regex.format, emailRegex).evaluate(with: candidate)
    }
    
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex = Regex.password.rawValue
        return NSPredicate(format: Regex.format, passwordRegex).evaluate(with: candidate)
    }
}
