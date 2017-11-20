//
//  HomeViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/13/17.
//  Copyright © 2017 Apple. All rights reserved.


import UIKit
import Firebase
import FirebaseDatabase


class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // Create an array of Activity Feed Objects
    var feed = [ActivityFeed]()
    var posts = [ActivityPostModel]()//empty model to populate
    
    private lazy var feedRef: DatabaseReference = Database.database().reference().child("Activity")         //:: Reference variable initialized to our Firebase reference
     private lazy var postRef: DatabaseReference = Database.database().reference().child("ActivityPost")
    var databaseHandle: DatabaseHandle? //:: Will retrieve reference from update feeds (fetchInfo())
    
    var selectedSegment = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func activitySegmentedSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 1
        } else {
            selectedSegment = 2
        }
        
        self.tableView.reloadData()//reload data when view changes
        
    }
    
    
    var tapButton: UITapGestureRecognizer!
    var superIndexPath: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self;
        tapButton = UITapGestureRecognizer(target: self, action: #selector(ActivityViewController.showActivity(recognizer:)))
        fetchFeed()
        fetchPosts()
      //  fetchInfo()//DIOS HAS A HORSE DICK
    }
    
    func fetchFeed() {
        
        feedRef.observe(DataEventType.value, with: { snapshot in
            self.feed.removeAll() // empty object
            guard let retrievedObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Could not retrieve objects")
                return
            }
   
            for activity in retrievedObjects {
                
                guard let feed = activity.value as? [String: AnyObject] else {
                    print("Failed to cast inventory as dictionary")
                    return
                }
                
                let object = ActivityFeed(userName: feed["userName"] as? String,
                                          itemName: feed["itemName"] as? String,
                                          profileImageUrl: feed["profileImageUrl"] as? String,
                                          timeStamp: feed["timestamp"] as? String,
                                          unitType: feed["units"] as? String,
                                          amount: feed["amount"] as? Int)
                self.feed.insert(object, at: 0)//populate model with fetched firebase data
            }
        })
        
        // Gotta Read More About This ****
        DispatchQueue.main.async
        {
                self.tableView.reloadData()  //:: Continously Update Information From Firebase
        }
    }
    
    func fetchPosts(){
        
        //:: PostRef will observe the child "Activty Post" in Firebase
        //:: Then will store their values inside an object : receivedPostObjects
        postRef.observe(DataEventType.value, with:{  snapshot in
            guard let receivedPostObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Failed to receive Activity Post Objects");
                return
            }
            
            //:: For all the post values (allPosts) in the Post Objects (receivedPostObjects)
            //:: The children values will be casted to Strings (guard is used for exception handling)
            for allPosts in receivedPostObjects{
                guard let uniquePost = allPosts.value as? [String: AnyObject] else {
                    print("Failed to Cast Values of Activity Posts to Strings")
                    return
                }
            
                //:: These new Post Objects will contain the values for each unique post
            let postObject = ActivityPostModel(userPost: uniquePost["post"] as? String,
                                               userTimestamp: uniquePost["timestamp"] as? String,
                                               userProfileImage: uniquePost["profileImageUrl"] as? String,
                                               userName: uniquePost["userName"] as? String)
            
                //:: Then they will be inserted to the posts array
            self.posts.insert(postObject, at: 0)
            }
        })
                    // Gotta Read More About This ****
                    DispatchQueue.main.async
                        {
                            self.tableView.reloadData()  //:: Continously Update Information From Firebase
                    }
    }
    
//    func fetchInfo()
//    {
//        //:: Set up reference for our Firebase (specifically to Users branch)
//        ref = Database.database().reference().child("Inventory")
//
//        //:: Retrieve (temporarily) user info
//        //:: child (Users) - observe the "Users" tab in Firebase
//        //:: .childAdded - updates user list incase new users were added
//
//        databaseHandle = ref.observe(DataEventType.value, with: { (snapshot) in
//            //:: Executed code when a new "User" has been added
//            //:: Take the data from snapshot and append it inside the feed array
//            self.feed.removeAll();
//            for information in snapshot.children.allObjects as! [DataSnapshot]
//            {
//                guard let firebaseResponse = snapshot.value as? [String: Any] else
//                {
//                    print("Snapshot is nil hence no data returned");
//                    return;
//                }
//                //                let info = information.value as? [String: AnyObject]
//                //                let username = info?["userID"] as! String?
//                //                let company = info?["userTeam"] as! String?
//                //                let position = info?["userTeam"] as! String?
//                //                let profileImageUrl = info?["userPic"] as! String?
//                //                let priority = info?["priority"] as! String?
//                //                let timeStamp = info?["timeStamp"] as! String?
//
//                let info = information.value as? [String: AnyObject]
//                let username = "Tester"
//                let item_name = info?["itemName"] as! String?
//                let company = "Test"
//                let profileImageUrl = info?["profileImageUrl"] as! String?
//                let item_amount = info?["amount"] as! String?
//                let timeStamp = info?["timestamp"] as! String?
//
//                let activity = ActivityFeed(username: username, company: company, profileImageUrl: profileImageUrl, timeStamp: timeStamp, userPic: "", postID: nil)
//
//
//                self.feed.append(activity)
//            }
//            // Gotta Read More About This ****
//            DispatchQueue.main.async
//                {
//                    self.tableView.reloadData()  //:: Continously Update Information From Firebase
//            }
//        })
//    }
    
    func showActivity(recognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: "showActivityComment", sender: self)  //segue to new controller
    }
    
    
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedSegment == 1 {
            return feed.count
        } else {
            return posts.count
        }
        
        //return feed.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "actFeedCell") as! ActivityViewCell
        let postCell = tableView.dequeueReusableCell(withIdentifier: "actPostCell") as! ActivityPostCell
        
        let feedObject = feed[indexPath.row]
        let postObject = posts[indexPath.row]//accesser to model objects to populate cell
        ///****
        ///////////////// Allocating data from firebase to the FEED OBJECT CELL
        feedCell.itemName.text = feedObject.itemName
        feedCell.amount.text = String(describing: feedObject.amount!)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateformatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
        let dateFromString = dateformatter.date(from: feedObject.timeStamp!)
        let timeAgo: String = self.timeAgoSinceDate((dateFromString)!, numericDates: true)
        feedCell.timeStamp.text = timeAgo
        
        feedCell.unitType.text = feedObject.unitType
        
        if let profileImage = feedObject.profileImageUrl {
            feedCell.userPic.loadImageUsingCacheWithUrlString(urlString: profileImage)
        }
        //*****
        //////////////////NOW Allocating data from firebase to the POST OBJECT CELL
        
        postCell.activityUserName.text = postObject.userName
        postCell.activityPost.text = postObject.userPost
        
        let postDateString = dateformatter.date(from: postObject.userTimestamp!) //new var to create the post timestamp
        let postTimeStamp = self.timeAgoSinceDate(postDateString!, numericDates: true)
        postCell.activityTimeStamp.text = postTimeStamp
        
        if let profileImage = postObject.userProfileImage {
            postCell.activityUserImage.loadImageUsingCacheWithUrlString(urlString: profileImage)
        }
        //////////// finished creating post block
        //****
        
        if selectedSegment == 1 {
            return feedCell
        } else {
            return postCell
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //:: If Segue Destination is validly set towards ActivitySelected Controller (casted)
        if let activity_selected  = segue.destination as? ActivitySelectedController
        {
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath //:: Attain index path based on selected row from TableView
            
//            //:: Set ActivitySelected information as that attained by the Feed Array on the selected TableView cell
//            activity_selected.username = feed[indexPath.row].username
//            activity_selected.userteam = feed[indexPath.row].company
//            activity_selected.timestamp = feed[indexPath.row].timeStamp
            
        }
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
