//
//  PostCommentCellTableViewCell.swift
//  Rim
//
//  Created by Luis Mejia on 12/6/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class PostCommentCellTableViewCell: UITableViewCell {

    

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var comment: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
