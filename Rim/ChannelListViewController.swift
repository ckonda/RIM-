//
//  ChannelListViewController.swift
//  Rim
//
//  Created by Chatan Konda on 10/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase

class ChannelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum Section: Int {//to hold the different tableview sections
        case createNewChannelSection = 0
        case currentChannelsSection
    }
    
    var senderDisplayName: String? // Person sending chat info
    var newChannelTextField: UITextField? // textfield for new channel input
    private var channels: [Channel] = [] //holding for channels model data
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("Channels")
    private var channelRefHandle: DatabaseHandle?

    @IBOutlet weak var tableView: UITableView!

     func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // # of sections in Tableview
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //creating the sections on tableview
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"//to switch between reuse identifiers on new and existing cells
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? CreateChannelCell {
                
                    newChannelTextField = createNewChannelCell.newChannelNameField//setting newly created channel from ChannelCell to the text field
               
            }
        } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            
            if let channelCell = cell as? ChannelCell {
                
                let channel = channels[indexPath.row]
                
                channelCell.channelName.text = channels[(indexPath as NSIndexPath).row].channelName
                
                channelCell.timeStamp.text = ""
                
                let timeQuery = Database.database().reference().child("Channels")//.child(channel.channelID!)//.child("messages").queryLimited(toLast: 1)
                
//                let timeQuery2 = timeQuery.child("messages").queryLimited(toLast: 1)
//                
//                timeQuery.observe(DataEventType.value, with: { (snapshot) in
//                    
//                    
//              //      print(snapshot.childrenCount)
//      
//                  
////                    if snapshot.childrenCount > 2{
////                        print("present")
////                        channelCell.timeStamp.text = "Activity Here"
////                    
////                    }else if !snapshot.hasChild("messages"){
////                    
////                        channelCell.timeStamp.text = ""
////                    }
//                    
//                    
//                })
                
            //    timeQuery.observeEvent(of: DataEventType.childAdded, with: { (snapshot) in
                
//                    if snapshot.hasChild(<#T##childPathString: String##String#>){
//                        print("present")
//                        
//                    }else{
//                        
//                        print("null")
//                    }
//                    

                   // let time = snapshot.value as! [String: Any]
                    
                    //print(time)
                
//                    let messageTime = time["timestamp"] as? String
//                    //
//                    let dateString = messageTime
//                    let dateformatter = DateFormatter()
//                    dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//                    dateformatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
//                    let dateFromString = dateformatter.date(from: dateString!)
//                    let timeAgo: String = self.timeAgoSinceDate((dateFromString)!, numericDates: true)
//                
//                    channelCell.timeStamp.text = timeAgo
                    
              //  })

           }
    
        }
        return cell
    }
    
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(DataEventType.childAdded, with: { (snapshot) in
            let id = snapshot.key//accessing the id key of each channel to dig in later on
            let newRef = snapshot.ref

            newRef.observe(DataEventType.value, with: { (snapshot) in
                
                let channelNames = snapshot.value as? [String: AnyObject]
                //print(channelNames)
                
                if let name = channelNames?["channelName"] as? String {
         
                    let isUnique = !self.channels.contains { channel in//bug fix to stop channel load duplication
                        return channel.channelID == id
                    }
                    
                    if isUnique {
                        self.channels.insert(Channel(channelID: id, channelName: name, latestMessageTimeStamp: nil), at: 0)
                    }
                }
                self.tableView.reloadData()
                
            })
                        
        })
    }
    
    @IBAction func createChannel(_ sender: Any) {
        
        if let name = newChannelTextField?.text { //
            
            if name.characters.count > 0 {//nil checker
 
                let newChannelRef = channelRef.childByAutoId() //storing channel name on button action to Firebase
                let channelItem = [
                    "channelName": name
                ]
                newChannelRef.setValue(channelItem)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        if segue.identifier == "ShowChannel" {
            if let channel = sender as? Channel {
                
                let chatVc = segue.destination as! ChatViewController
                
                segue.destination.hidesBottomBarWhenPushed = true
                
                chatVc.senderDisplayName = senderDisplayName
                chatVc.channel = channel
                chatVc.channelRef = channelRef.child(channel.channelID!)
                
                chatVc.senderId = AppDelegate.user.userID
                chatVc.senderDisplayName = AppDelegate.user.username
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = channels[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "ShowChannel", sender: message)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannels()
        
         self.hideKeyboardWhenTappedAround()//when view is tapped outside of the box, dismiss

    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {//returns string of time of message sent
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
