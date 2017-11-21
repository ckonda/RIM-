//
//  ActivityPostModel.swift
//  Rim
//
//  Created by Chatan Konda on 11/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit


public class ActivityPostModel: NSObject
{
    var userPost: String?
    var userTimestamp: String?
    var userProfileImage: String?
    var userName: String?
    
    init(userPost: String?, userTimestamp: String?, userProfileImage: String?, userName: String?)
    {
        self.userPost = userPost
        self.userTimestamp = userTimestamp
        self.userProfileImage = userProfileImage
        self.userName = userName
    }
    
    
}
