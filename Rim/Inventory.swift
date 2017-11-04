//
//  Inventory.swift
//  Rim
//
//  Created by Chatan Konda on 10/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

public class Inventory: NSObject {
    var profileImageUrl: String?
    var username: String?
    var timeStamp: String?
    var shipDate: String?
    var item_name: String?
    var units: String?
    var amount: String?
    
    var userID: String?
    var inventoryID: String?
    var company: String?
    
    init(username: String?, profileImageUrl: String?, timeStamp: String?, item_name: String?,  inventoryID: String?, amount: String? , userID: String?, shipDate: String?, units: String?, company: String?) {
        
        self.username = username
        self.timeStamp = timeStamp
        self.profileImageUrl = profileImageUrl
        self.company = company
        
        self.item_name = item_name
        self.amount = amount
        self.shipDate = shipDate
        self.units = units
        self.userID = userID
        self.inventoryID = inventoryID
        
    }
}
