//
//  MyTeam.swift
//  Rim
//
//  Created by Chatan Konda on 9/25/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

public class MyTeam: NSObject {
    var username: String?
    var email: String?
    var password: String?
    var userID: String?
    var profileImageUrl: String?
    var position: String?
    var company: String?
    
    init(username: String?, email: String?, userID: String?, profileImageUrl: String?, position: String?, company: String?) {
        self.username = username
        self.email = email
        self.userID = userID
        self.profileImageUrl = profileImageUrl
        self.position = position
        self.company = company
    }

}
