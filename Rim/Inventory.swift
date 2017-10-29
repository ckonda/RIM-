//
//  Inventory.swift
//  Rim
//
//  Created by Chatan Konda on 10/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

public class Inventory: NSObject
{
    var profileImageUrl: String?
    var priorityTag: String?
    var username: String?
    var company: String?
    var timeStamp: String?
    var item_name: String?
    var position: String?
    var password: String?
    var userID: String?
    var inventoryID: String?
    
    
    init(username: String?, company: String?, profileImageUrl: String?, timeStamp: String?, userPic: String?, priority: String?, item_name: String?, position: String?, inventoryID: String? )
    {
        
        self.username = username
        self.company =  company
        self.timeStamp = timeStamp
        self.profileImageUrl = profileImageUrl
        self.priorityTag = priority
        
        self.item_name = item_name
        self.position = position
        
        self.inventoryID = inventoryID
        
        
    }
    
    
    
    
    
    
}
