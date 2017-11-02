//
//  InventoryCell.swift
//  Rim
//
//  Created by Chatan Konda on 10/23/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit


class InventoryCell: UITableViewCell {
    
    
    
    @IBOutlet weak var inventoryName: UILabel!
    
    @IBOutlet weak var productPic: UIImageView!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var units: UILabel!
    
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    
    
    
    
}
