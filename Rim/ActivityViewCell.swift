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
    
    @IBOutlet var activityImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userTeam: UILabel!
    @IBOutlet var timeStamp: UILabel!
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var priority: UILabel!
    
   public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
