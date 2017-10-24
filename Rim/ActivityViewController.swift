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
    
   
    var ref: DatabaseReference!         //:: Reference variable initialized to our Firebase reference
    var databaseHandle: DatabaseHandle? //:: Will retrieve reference from update feeds (fetchInfo())
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self;
        fetchInfo()
    }
    
    func fetchInfo()
    {
        
        //:: Set up reference for our Firebase (specifically to Users branch)
        ref = Database.database().reference().child("Activity")
        
        //:: Retrieve (temporarily) user info
        //:: child (Users) - observe the "Users" tab in Firebase
        //:: .childAdded - updates user list incase new users were added
        
        databaseHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            //:: Executed code when a new "User" has been added
            //:: Take the data from snapshot and append it inside the feed array
            self.feed.removeAll();
            for information in snapshot.children.allObjects as! [DataSnapshot]
            {
                guard let firebaseResponse = snapshot.value as? [String: Any] else
                {
                    print("Snapshot is nil hence no data returned");
                    return;
                }
                let info = information.value as? [String: AnyObject]
                let username = info?["userName"] as! String?
                let company = info?["userTeam"] as! String?
                let position = info?["userTeam"] as! String?
                let profileImageUrl = info?["userPic"] as! String?
                let priority = info?["priority"] as! String?
                let timeStamp = info?["timeStamp"] as! String?
                
                
                let activity = ActivityFeed(username:username, company:company, profileImageUrl:profileImageUrl, timeStamp:timeStamp, userPic:profileImageUrl, priority:priority, postID: nil)
                self.feed.append(activity)
            }
            // Gotta Read More About This ****
            DispatchQueue.main.async
            {
                self.tableView.reloadData()  //:: Continously Update Information From Firebase
            }
        })
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return feed.count
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let activity_feed_cell = tableView.dequeueReusableCell(withIdentifier: "act_cell", for: indexPath as IndexPath) as! ActivityViewCell
        let activity_feed = feed[indexPath.row]
        
        activity_feed_cell.userName.text = activity_feed.username
        activity_feed_cell.userTeam.text = activity_feed.company
        activity_feed_cell.priority.text = activity_feed.priorityTag
        activity_feed_cell.timeStamp.text = activity_feed.timeStamp
        return activity_feed_cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //:: If Segue Destination is validly set towards ActivitySelected Controller (casted)
        if let activity_selected  = segue.destination as? ActivitySelectedController
        {
            let indexPath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath //:: Attain index path based on selected row from TableView

            //:: Set ActivitySelected information as that attained by the Feed Array on the selected TableView cell
            activity_selected.username = feed[indexPath.row].username
            activity_selected.userteam = feed[indexPath.row].company
            activity_selected.timestamp = feed[indexPath.row].timeStamp
            
        }
    }
}
