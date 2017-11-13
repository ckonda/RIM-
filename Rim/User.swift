//
//  User.swift
//  Rim
//
//  Created by Chatan Konda on 9/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

public class User: NSObject {
    var username: String?
    var email: String?
    var password: String?
    var userID: String?
    var profileImageUrl: String?
    var position: String?
    var company: String?
    
    func initialize(username: String?, email: String?, password: String?, userID: String?, profileImageUrl: String?, position: String?, company: String?) {
        self.username = username
        self.email = email
        self.password = password
        self.userID = userID
        self.profileImageUrl = profileImageUrl
        self.position = position
        self.company = company
    }
    
}
//struct User {
//    var username: String?
//    var email: String?
//    var password: String?
//    var userID: String?
//    var profileImageUrl: String?
//    var position: String?
//    var company: String?
//    
//        mutating func initialize(username: String?, email: String?, password: String?, userID: String?, profileImageUrl: String?, position: String?, company: String?) {
//            self.username = username
//            self.email = email
//            self.password = password
//            self.userID = userID
//            self.profileImageUrl = profileImageUrl
//            self.position = position
//            self.company = company
//        }
//
//}
