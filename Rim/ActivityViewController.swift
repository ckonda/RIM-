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
    
    //:: Test 2D array

    var cFeedIndex: Int!
    
    private lazy var feedRef: DatabaseReference = Database.database().reference().child("Activity")         //:: Reference variable initialized to our Firebase reference
     private lazy var postRef: DatabaseReference = Database.database().reference().child("ActivityPost")
    var databaseHandle: DatabaseHandle? //:: Will retrieve reference from update feeds (fetchInfo())
    
    var selectedSegment = 0
    
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
        cFeedIndex = 0
  
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
    
    func showActivity(recognizer: UITapGestureRecognizer)
    {
        print("Clicked...")
        performSegue(withIdentifier: "showActivityComment", sender: self)  //segue to new controller
    }
    
    
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedSegment == 0 {
            return feed.count
        } else {
            return posts.count
        }
     
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let feedCell = tableView.dequeueReusableCell(withIdentifier: "actFeedCell") as! ActivityViewCell
        let postCell = tableView.dequeueReusableCell(withIdentifier: "actPostCell") as! ActivityPostCell

       // if cFeedIndex == 0 {
            let feedObject = feed[indexPath.row]
            ///****
            ///////////////// Allocating data from firebase to the FEED OBJECT CELL
            feedCell.itemName.text = feedObject.itemName
            feedCell.amount.text = String(describing: feedObject.amount!)
            feedCell.unitType.text = feedObject.unitType
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//            dateformatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
//            dateformatter.locale = NSLocale.current
//            let dateFromString = dateformatter.date(from: feedObject.timeStamp!)
//            let timeAgo: String = self.timeAgoSinceDate((dateFromString)!, numericDates: true)
            
            feedCell.timeStamp.text = "10 minutes ago"
            
            if let profileImage = feedObject.profileImageUrl {
                feedCell.userPic.loadImageUsingCacheWithUrlString(urlString: profileImage)
            }
       // }
        
      //  else if cFeedIndex == 1 {
            let postObject = posts[indexPath.row]//accesser to model objects to populate cell
            
            //*****
            //////////////////NOW Allocating data from firebase to the POST OBJECT CELL
            
            postCell.activityUserName.text = postObject.userName
            postCell.activityPost.text = postObject.userPost
//            let dateformatter = DateFormatter()
//            dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//            dateformatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
//            dateformatter.locale = NSLocale.current
//            let postDateString = dateformatter.date(from: postObject.userTimestamp!) //new var to create the post timestamp
//            let postTimeStamp = self.timeAgoSinceDate(postDateString!, numericDates: true)
//            postCell.activityTimeStamp.text = postTimeStamp
            postCell.activityTimeStamp.text = "20 minutes ago"
            
            if let profileImage = postObject.userProfileImage {
                postCell.activityUserImage.loadImageUsingCacheWithUrlString(urlString: profileImage)
            }
            //////////// finished creating post block
            //****
  
       // }
        if selectedSegment == 1 {//logic to return cell we need
            return feedCell
        } else {
            return postCell
        }
       
    }
    
    //:: Retrieving Index of Selected Table Row Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //segemented control logic
        if selectedSegment == 1 {//passing data to feed cell if we need anything there
            performSegue(withIdentifier: "showActivityFeedComment", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else { //passing data to the post comment section on user tap of cell
            print("on user click to post comment section, will create")
            
        }
    
//        let index = indexPath.row
//        //:: Instantiate a type of "ActivityCommentController" (check storyboard ID)
//        let activityCommentControllerAccessor = self.storyboard?.instantiateViewController(withIdentifier: "ActivityCommentController") as! ActivityCommentController
//        //:: Access ActivityCommentController's labels (name,timeStamp,etc.)
//        //:: Then set the labels equal to values inside the ActivityFeedObject (using index for Feed Array)
//        guard let feedUserName = self.feed[index].userName else{
//            print("No value in Feed Object User Name\n");
//            return
//        }
//        guard let feedActivityItemName = self.feed[index].itemName else {
//            print("No value in Feed Object Item\n");
//            return
//        }
//        guard let feedItemAmount = self.feed[index].amount else {
//            print("No Value in Feed Object amount");
//            return
//        }
////        guard let feedTimeStamp = feed[index].timeStamp else {
////            print("No Value in Feed Time Stamp");
////            return
////        }
//
//        activityCommentControllerAccessor.activityUserName = feedUserName
//        activityCommentControllerAccessor.activityItemName = feedActivityItemName
//        activityCommentControllerAccessor.activityItemAmount = String(describing: feedItemAmount)
        //activityCommentControllerAccessor.setLabels()
//        activityCommentControllerAccessor.timeStamp.text = feedTimeStamp
        
//        print("\(activityCommentControllerAccessor.userName.text)\n")
//        print("\(activityCommentControllerAccessor.activityInfo.text)\n")
//        print("\(activityCommentControllerAccessor.itemAmount.text)\n")
//        print("\(feedUserName)\n")
//        print("\(feedActivityItemName)\n")
//        print("\(feedItemAmount)\n")
//        print("\(feedTimeStamp)\n")
        print("Supposedly finished initialization")
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedSegment == 1{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let activityFeedCommentView = segue.destination as? ActivityCommentController
                
                activityFeedCommentView?.activityUserName = feed[indexPath.row].userName
                activityFeedCommentView?.activityItemName = feed[indexPath.row].itemName
                activityFeedCommentView?.activityItemAmount = feed[indexPath.row].amount
//                activityFeedCommentView?.activityTimeStamp = feed[indexPath.row].timeStamp
   
            }
            
        } else {
            
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
