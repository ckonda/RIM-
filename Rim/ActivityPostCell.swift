//  ActivityPostCell.swift
//  Rim
//
//  Created by Chatan Konda on 11/18/17.
//  Copyright © 2017 Apple. All rights reserved.

import Foundation
import UIKit

public class ActivityPostCell: UITableViewCell {
    
    @IBOutlet weak var activityPost: UITextView! //change to text view
    
    @IBOutlet weak var activityUserName: UILabel!
    @IBOutlet weak var activityTimeStamp: UILabel!
    @IBOutlet weak var activityUserImage: UIImageView!

    public override func awakeFromNib() {
        activityUserImage.layer.cornerRadius = activityUserImage.frame.size.width/2
        activityUserImage.clipsToBounds = true
        activityUserImage.layer.borderColor = UIColor.white.cgColor
        activityUserImage.layer.borderWidth = 1
    }
}
