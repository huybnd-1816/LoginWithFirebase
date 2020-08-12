//
//  Constant.swift
//  LoginWithFirebase
//
//  Created by mac on 6/1/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

enum ErrorDescription: String {
    case fieldIsNil = "Please fill out all required fields"
    case emailIsInvalid = "Your email is invalid"
    case passwordIsInvalid = "Your password is invalid"
}

enum LoginProviders: String, CaseIterable {
    case Email = "password"
    case Facebook = "facebook.com"
    case Google = "google.com"
    
    func allProviders() -> [String] {
        return LoginProviders.allCases.map { $0.rawValue }
    }
}

enum AccountStatus {
    case unknown
    case registered
    case unregistered
}
