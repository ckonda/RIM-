//
//  Inventory.swift
//  Rim
//
//  Created by Chatan Konda on 10/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

//enum UnitType {
//    case boxes
//    case turtles
//}
//
//struct Inventory {
//    let profileImageURL: String?
//    let owner: String?
//    let timeStamp: String?
//    let shipDate: String?
//    var itemName: String?
//    var unitType: UnitType // Enum UnitType
//    
//    // Example
//    func doSomething() {
//        switch unitType {
//        case .boxes: print("doing something")
//        case .turtles: print("doing turltes")
//        }
//    }

//    init(owner: String) {
//        self.owner = owner
//    }
    
//    init(of tpye: UnitType) {
//        owner = type
//    }
//}

//let object = Inventory(
//    profileImageURL: <#T##String?#>,
//    owner: <#T##String?#>,
//    timeStamp: <#T##String?#>,
//    shipDate: <#T##String?#>,
//    itemName: <#T##String?#>,
//    unitType: <#T##UnitType#>
//)

//let obejct2 = Inventory(owner: "Chatan")

//let object3 = Inventory(of: )

public class Inventory: NSObject {
    
    var profileImageUrl: String?
    var username: String?
    var timeStamp: String?
    var shipDate: String?
    var item_name: String?  // camelCase
    var units: String?
    var amount: Int?
    
    var userID: String?
    var inventoryID: String?
    var company: String?
    
    init(username: String?, profileImageUrl: String?, timeStamp: String?, item_name: String?, inventoryID: String?, amount: Int?, userID: String?, shipDate: String?, units: String?, company: String?) {
        
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
