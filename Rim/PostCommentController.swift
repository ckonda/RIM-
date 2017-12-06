//
//  PostCommentController.swift
//  Rim
//
//  Created by Luis Mejia on 12/5/17.
//  Copyright © 2017 Apple. All rights reserved.
//


import UIKit
//import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class PostCommentController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //:: Set Up Firebase Reference with 'PostComments' child
    private lazy var Ref: DatabaseReference = Database.database().reference().child("PostComments")
    
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postTimeStamp: UILabel!
    @IBOutlet weak var postUserPic: UIImageView!
    

    
    @IBOutlet weak var postCommentTableView: UITableView!
    
    @IBOutlet weak var postContent: UITextView!
    
    var databaseRef: DatabaseReference!
    
    var activityPostUserName = String()
    var activityPostTimeStamp =  String()
    var activityPostContent =  String()
    var activityPostImageURL = String()
    var activityPostID = String() //:: ID of Post inside Firebase
    //:: Array of Comments
    var postComments = [ActivityComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postCommentTableView.delegate = self;
        postCommentTableView.dataSource = self;
        
        postUserPic.layer.cornerRadius = postUserPic.frame.size.width/2
        postUserPic.clipsToBounds = true
        postUserPic.layer.borderColor = UIColor.white.cgColor
        postUserPic.layer.borderWidth = 1
    
    }
    
    func getCurrentDate() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
    
    func populateLabels(){
        guard !activityPostUserName.isEmpty else {
            print("No username passed in")
            return
        }
        
        postUserName.text = activityPostUserName
        postTimeStamp.text = activityPostTimeStamp
        postContent.text = activityPostContent
        
        Storage.storage().reference(forURL: activityPostImageURL).downloadURL { (data, error) in
            self.postUserPic.loadImageUsingCacheWithUrlString(urlString: self.activityPostImageURL)
        }
        
    }
    
    override func awakeFromNib() {
        print("Post Comment Controller Awake From Nib")
        let _ = self.view
    }
    //:: Code Referenced from Brian Advent YouTube channel
    @IBAction func addComment(_ sender: UIButton) {
        //:: Initializing Alert Box
        let commentAlert = UIAlertController(title: "New Comment", message: "Enter Your Comment", preferredStyle: .alert)
        //:: Placing Place Holder Text in Alert Box
        commentAlert.addTextField{(textField: UITextField!) -> Void in textField.placeholder = "Comment..."}
        
        commentAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: {(action: UIAlertAction) in
            if let commentContent = commentAlert.textFields?.first?.text{
                //:: This is where the JSON logic must take place
                //:: We must reference the respective 'postID' in order to display the right comments on the right post
                let commentID = self.Ref.child(self.activityPostID).childByAutoId()
                
                //:: Set up the comment block
                let commentBlock = [
                    "comment": commentContent,
                    "timeStamp": self.getCurrentDate()!,
                    "userName" : AppDelegate.user.username!,
                    "profileImageURL": AppDelegate.user.profileImageUrl!]
                    as [String: Any]
                
                commentID.setValue(commentBlock)
            }
        }))
        
        commentAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(commentAlert, animated: true, completion: nil)
    }
    
    //:: Code Referenced from Brian Advent YouTube channel
    func observeComments() {
        //:: Checking the Comments from Respective Post ID
        Ref.child(activityPostID).observe(DataEventType.value, with: {(snapshot: DataSnapshot) in
            
            //:: Retrieving all data and storing it into array
            guard let commentData =
            snapshot.children.allObjects as? [DataSnapshot] else {
                print ("Data unreachable")
                return
            }
            
            for comment in commentData {
                guard let comments = comment.value as? [String: AnyObject] else {
                    print("Failed to cast data objects as dictionary")
                    continue
                }
                
                let commentObject = ActivityComment(
                    profileImageURL: comments["profileImageURL"] as? String,
                    comment: comments["comment"] as? String,
                    username: comments["userName"] as? String,
                    timeStamp: comments["timeStamp"] as? String)
                
                print(commentObject.comment)
                self.postComments.insert(commentObject, at: 0)
            }
            self.postCommentTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Amount of Comments on this post: \(postComments.count)")
        return postComments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 // height for each row column to be at
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postCommentTableView.dequeueReusableCell(withIdentifier: "postCommentCell", for: indexPath) as! PostCommentCellTableViewCell
        
        let comment = postComments[indexPath.row]
        cell.username.text = comment.username
        cell.timeStamp.text = comment.timeStamp
        cell.comment.text = comment.comment
        
        if let profilePic = comment.profileImageURL {
            cell.userImage.loadImageUsingCacheWithUrlString(urlString: profilePic)
        }
        return cell
    }
    
    func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {//returns string of time of message sent
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if components.month! >= 2 {
            return "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if components.day! >= 2 {
            return "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        } else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    
    
}
