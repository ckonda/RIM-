//
//  ActivityFeed.swift
//  Rim
//
//  Created by Luis Mejia on 10/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

public class ActivityFeed: NSObject {
    //var activityImage: String?
    var profileImageUrl: String?
    var priorityTag: String?
    var username: String?
    var company: String?
    var timeStamp: String?
    var item_name: String?
    var position: String?
    var password: String?
    var userID: String?
    var postID: String?
    
    init(username: String?, company: String?, profileImageUrl: String?, timeStamp: String?, userPic: String?, priority: String?, postID: String?) {
        self.username = username
        self.company =  company
        self.timeStamp = timeStamp
        self.profileImageUrl = profileImageUrl
        self.priorityTag = priority
        
        self.postID = postID
    }

}
