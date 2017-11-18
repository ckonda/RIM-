//
//  ActivitySelectedController.swift
//  Rim
//  Created by Luis Mejia on 10/14/17.
//  Copyright © 2017 Apple. All rights reserved.

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
//import JSQMessagesViewController

class ActivitySelectedController: UIViewController
{
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var userTeamName: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    var username: String?
    var userteam: String?
    var timestamp: String?
    var activity_title: String?
    var activtiy_image: UIImage?
    
    
    override func viewDidLoad() {
        populate_info()
    }
    
    func populate_info()
    {
        userName?.text = username
        userTeamName?.text = userteam
        timeStamp?.text = timestamp
        activityTitle?.text = activity_title
    }
}

