//
//  ActivityCommentCell.swift
//  Rim
//
//  Created by Luis Mejia on 11/1/17.
//  Copyright © 2017 Apple. All rights reserved.
//
import Foundation
import UIKit

class ActivityCommentCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var commentContent: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.borderWidth = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

