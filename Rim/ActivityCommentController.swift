//
//  ActivityCommentController.swift
//  Rim
//
//  Created by Luis Mejia on 11/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ActivityCommentController: UITableViewController {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var activityInfo: UILabel!
    @IBOutlet weak var timeStamp: UILabel!

    
    var commentsArr = [ActivityComment]()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    public var activityUserName = String()
    public var activityItemAmount = Int()
    public var activityItemName = String()
    public var activityTimeStamp = String()
    
    var activity_comments = [ActivityComment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setLabels()
        databaseRef = Database.database().reference().child("Comments")
        observeComments()
    
    }
    override func awakeFromNib() {
        print("Comment Controller Awake From Nib")
        let _ = self.view
    }
//    func setLabels()
//    {
//        self.userName.text = activityUserName
//        self.itemAmount.text = activityItemAmount
//        self.activityInfo.text = activityInformation
//
//        print("Insed SetLabels:\n")
//        print("\(self.userName.text)\n")
//        print("\(self.itemAmount.text)\n")
//        print("\(self.activityInfo.text)\n")
//        print("Finished Printing...")
////        guard let userName.text = activityUserName else {
////            print("In ActivityCommentController: Found Nil in User Name\n")
////            return
////        }
////        guard let itemAmount.text = activityItemAmount else {
////            print("In ActivityCommentController: Found Nil in Item Amount\n")
////            return
////        }
////        guard let activityInfo.text = activityInformation else {
////            print("In ActivityCommentController: Found Nil in Activity Information\n")
////            return
////        }
//    }
    func start()
    {
        self.activityInfo.text = ""
        self.userName.text = ""
        self.itemAmount.text = ""
        self.timeStamp.text = ""
    }
    @IBAction func addComment(_ sender: Any) {
        let commentAlert = UIAlertController(title: "New Comment", message:"Enter Your Comment", preferredStyle: .alert)
        
        commentAlert.addTextField {(textField: UITextField!) -> Void in textField.placeholder =  "Comment..."}
        
        commentAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let commentContent = commentAlert.textFields?.first?.text{
                let comment = ActivityComment(content: commentContent, username: Firebase.Auth.auth().currentUser!.uid)
                let commentReference = self.databaseRef.child(commentContent.lowercased())
                commentReference.setValue(comment.toAnyObject())
            }
        }))
        
        self.present(commentAlert, animated:true, completion: nil)
        
    }
    
    
    func observeComments()
    {
        databaseRef.observe(.value, with: { (snapshot: DataSnapshot) in
            var newComments = [ActivityComment]()
            for comment in snapshot.children
            {
                let commentObject = ActivityComment(snapshot:comment as! DataSnapshot)
                newComments.append(commentObject)
            }
            self.activity_comments = newComments
            self.tableView.reloadData()
        })
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activity_comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! ActivityCommentCell

        // Configure the cell...
        let comment = activity_comments[indexPath.row]
        cell.textLabel?.text = comment.content
        cell.detailTextLabel?.text = comment.username
        
        
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
