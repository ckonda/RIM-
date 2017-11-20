//
//  Inventory.swift
//  Rim
//
//  Created by Chatan Konda on 10/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

struct Inventory {
    let profileImageURL: String?
    let shipmentSentUsername: String?//person who ordered the shipment
    let timeStamp: String?
    let shipDate: String?
    var itemName: String?
    var unitType: String? //unit types
    var quantity: Int?//old amount
    let userID: String?//
    let productID: String?//old inventory ID
    let company: String?
}
