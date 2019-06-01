//
//  Regex.swift
//  LoginWithFirebase
//
//  Created by mac on 6/1/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

enum Regex: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case password = "(?=.*[0-9])(?=.*[a-z]).{8,}" //at least one digit, one lowercase, 8 characters
    static let format = "SELF MATCHES %@"
}
