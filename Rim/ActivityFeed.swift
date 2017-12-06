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

    var profileImageUrl: String!
    var userName: String!
    var timeStamp: String!
    var itemName: String!
    var position: String!
    var userID: String!
    var inventoryID: String!
    var unitType: String!
    var amount: Int!
    
    init(userName: String!, itemName: String!, profileImageUrl: String!, timeStamp: String!, unitType: String!, amount: Int!, inventoryID: String! ) {
        self.userName = userName
        self.timeStamp = timeStamp
        self.profileImageUrl = profileImageUrl
        self.itemName = itemName
        self.unitType = unitType
        self.amount = amount
        self.inventoryID = inventoryID
    }

}

