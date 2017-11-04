//
//  myTeamCell.swift
//  Rim
//
//  Created by Chatan Konda on 9/25/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit



public class myTeamCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var position: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configure(name: String, position: String,profileImage:UIImage){
        
        self.name.text = name
        self.position.text = position
        self.profileImage.image = profileImage
    }
}
