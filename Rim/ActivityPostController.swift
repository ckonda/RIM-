//
//  ActivityPostController.swift
//  Rim
//
//  Created by Chatan Konda on 11/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase

class ActivityPostController: UIViewController, UITextFieldDelegate {
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("ActivityPost")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postStatus.layer.borderColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        postStatus.layer.borderWidth = 1.0
        postStatus.layer.cornerRadius = 5
        
        postButtonOutlet.layer.cornerRadius = 10
        postButtonOutlet.clipsToBounds = true
     
        
    }
  @IBOutlet weak var postStatus: UITextView!

    @IBOutlet weak var postButtonOutlet: UIButton!
    @IBAction func postButton(_ sender: Any) {
        
        sendPostToFirebase()
        navigationController?.popViewController(animated: true)//remove from stack of controllers
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        postStatus.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postStatus.resignFirstResponder()
        return true
    }
    
    func getCurrentDate() ->  (String?) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        return (stringDate)
    }
    
    func sendPostToFirebase() {
        
        if let post = self.postStatus.text, let timeStamp = getCurrentDate(), let profileImageURL = AppDelegate.user.profileImageUrl, let userID = AppDelegate.user.userID {
            
            let postRef = self.Ref.childByAutoId()//reference to firebase
            
            let status = [//to make sure the team aligns with each company
                "profileImageUrl": profileImageURL,
                "timestamp": timeStamp,
                "userID": userID,
                "postID": postRef.key,
                "post": post,
                "userName" : AppDelegate.user.username!,
                "company": AppDelegate.user.company! //comapny name added
                ] as [String: Any]
            
            postRef.setValue(status)//value placed in firebase JSON
        }

    }
    
    
    
    
}
