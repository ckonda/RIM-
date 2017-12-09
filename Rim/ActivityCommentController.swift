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

class ActivityCommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Comments")
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var activityInfo: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var commentsImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var databaseRef: DatabaseReference!
    
    var activityUserName = String()
    var activityItemAmount = Int()
    var activityItemName = String()
    var activityTimeStamp = String()
    var activityFeedID = String() //id of the comment post
    var activityFeedImageURL = String()
    
    var activityComments = [ActivityComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        observeComment()// placed in the previous vc to populate before view loads
        tableView.delegate = self
        tableView.dataSource = self
        
        commentsImage.layer.cornerRadius = commentsImage.frame.size.width/2
        commentsImage.clipsToBounds = true
        commentsImage.layer.borderColor = UIColor.white.cgColor
        commentsImage.layer.borderWidth = 1
        
        addCommentOutlet.layer.cornerRadius = 10
        addCommentOutlet.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
  //  populateLabels()
    }
    
    func populateLabels(){
        
        guard !activityUserName.isEmpty else {
            print("There was no username passed")
            return
        }
        
        userName.text = activityUserName
        itemAmount.text = String(describing: activityItemAmount)
        activityInfo.text = activityItemName
        timeStamp.text = activityTimeStamp
        
        Storage.storage().reference(forURL: activityFeedImageURL).downloadURL { (data, error) in
            self.commentsImage.loadImageUsingCacheWithUrlString(urlString: self.activityFeedImageURL)
        }
    }

    override func awakeFromNib() {
        print("Comment Controller Awake From Nib")
        let _ = self.view
    }

    func getCurrentDate() -> String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
    
    
    @IBOutlet weak var addCommentOutlet: UIButton!
    
    //:: Code Referenced from Brian Advent YouTube channel
    @IBAction func addComment(_ sender: Any) {
        let commentAlert = UIAlertController(title: "New Comment", message:"Enter Your Comment", preferredStyle: .alert)
        
        commentAlert.addTextField {(textField: UITextField!) -> Void in textField.placeholder =  "Comment..."}
        
        commentAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let commentContent = commentAlert.textFields?.first?.text{
                //comment JSON logic to be placed in firebase here
                let commentID = self.Ref.child(self.activityFeedID).childByAutoId()

                let commentBlock = [
                    "comment": commentContent,
                    "timeStamp": self.getCurrentDate()!,
                    "userName": AppDelegate.user.username!,
                    "profileImageURL": AppDelegate.user.profileImageUrl!
                    ] as [String: Any]

                commentID.setValue(commentBlock)
                
            }
        }))
        

        commentAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil))
        
        self.present(commentAlert, animated:true, completion: nil)
    }
    //:: Code Referenced from Brian Advent YouTube channel
    func observeComment() {
        
        Ref.child(activityFeedID).observe(DataEventType.value, with: { (snapshot: DataSnapshot) in
            self.activityComments.removeAll()
            guard let commentData = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Could not retrieve objects")
                return
            }

            for comment in commentData {
                guard let comments = comment.value as? [String: AnyObject] else {
                    print("Failed to cast inventory as dictionary")
                    continue
                }
                let commentObject = ActivityComment(profileImageURL: comments["profileImageURL"] as? String,
                                                    comment: comments["comment"] as? String,
                                                    username: comments["userName"] as? String,
                                                    timeStamp: comments["timeStamp"] as? String)
                print(commentObject.comment)
                self.activityComments.insert(commentObject, at: 0)
            }
            self.tableView.reloadData()
        })
        
    }
    
  

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activityComments.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // height for each row column to be at
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! ActivityCommentCell

        let comment = activityComments[indexPath.row]
        
        cell.userName.text = comment.username
        cell.commentContent.text = comment.comment
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateformatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
        dateformatter.locale = NSLocale.current
        let postDateString = dateformatter.date(from: comment.timeStamp) //new var to create the post timestamp
        let postTime = self.timeAgoSinceDate(postDateString!, numericDates: true)
        cell.postTime.text = postTime
        
        
        if let profileImage = comment.profileImageURL {
            cell.userImage.loadImageUsingCacheWithUrlString(urlString: profileImage)
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
