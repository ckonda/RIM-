//
//  ActivityViewCell.swift
//  Rim
//
//  Created by Luis Mejia on 10/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

public class ActivityViewCell: UITableViewCell
{
    
//    @IBOutlet var activityImage: UIImageView!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var amount: UILabel!
    @IBOutlet weak var commentIcon: UIImageView!//beak
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var unitType: UILabel!
    
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userPic.layer.cornerRadius = userPic.frame.size.width/2
        userPic.clipsToBounds = true
        userPic.layer.borderColor = UIColor.white.cgColor
        userPic.layer.borderWidth = 1
        
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

