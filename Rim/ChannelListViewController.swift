//
//  ChannelListViewController.swift
//  Rim
//
//  Created by Chatan Konda on 10/2/17.
//  Copyright © 2017 Apple. All rights reserved.
import UIKit
import Firebase

class ChannelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var senderDisplayName: String? // Person sending chat info
    
    private var channels: [Channel] = [] //holding for channels model data
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("Channels")

    @IBOutlet weak var channelsTableView: UITableView!//ref for the channels tableview
    
    @IBOutlet weak var newChannelTextField: UITextField!//new channel text input
    
    @IBAction func createChannelButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannels()
        self.hideKeyboardWhenTappedAround()//when view is tapped outside of the box, dismiss
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingChannel", for: indexPath)
        
            if let channelCell = cell as? ChannelCell {
                
                let channel = channels[indexPath.row]
                
                channelCell.channelName.text = channels[indexPath.row].channelName//setting channel name to cell form channel model
                
                let timeQuery = Database.database().reference().child("Channels").child(channel.channelID!)
                
                let timeQuery2 = timeQuery.child("messages").queryLimited(toLast: 1)//for time digging if channel created
                
                timeQuery.observe(DataEventType.value, with: { (snapshot) in
                    switch snapshot.childrenCount {
                    case 1:
                        print("Channel was created, not populated")
                        channelCell.timeStamp.text = ""
                    case 2:
                        timeQuery2.observeSingleEvent(of: DataEventType.childAdded, with: { (snapshot) in
                            guard let time = snapshot.value as? [String: Any] else {
                                print("error on time snapshot")//guard if does not caputure time JSON
                                return
                            }
                            if let messageTime = time["timestamp"] as? String {//translation from date to string for the cell
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                                dateformatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
                                let dateFromString = dateformatter.date(from: messageTime)
                                let timeAgo: String = self.timeAgoSinceDate((dateFromString)!, numericDates: true)
                                channelCell.timeStamp.text = timeAgo//time to text
                            }
                        })
                    default:
                        print("key has no children")//probably wont happen bc tree is meant to handle only two children based on input/creation
                    }
                })
                
           }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowChannel", sender: self)//channel segue for channels created
        channelsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRef.observe(DataEventType.childAdded, with: { (snapshot) in
            let id = snapshot.key//accessing the id key of each channel to dig in later on
            let newRef = snapshot.ref

            newRef.observe(DataEventType.value, with: { (snapshot) in
                
                let channelNames = snapshot.value as? [String: AnyObject]
                
//                if snapshot.childSnapshot(forPath: "messages").exists(){
//                    print("theres messags")
//                    newRef.child("messages").queryLimited(toLast: 1)
//
//                    let timeStamp = snapshot.childSnapshot(forPath: "messages")
//                    print(timeStamp!)
//
//                }else{
//
//                    print("no messages yet")
//                }
////
//                print(timeExists!)
//                guard let timeStamp = snapshot.childSnapshot(forPath: "messages").value as? [String: AnyObject] else {
//                    print("No timestamp here")
//                    return
//                }
//
//                guard let newTimeStamp = timeStamp["timestamp"] as? String else {
//                    print("can't find timestamp")
//                    return
//                }
//                print(newTimeStamp)
                
//                if let newTimeStamp = timeStamp["timestamp"] as? String {
//                    print(newTimeStamp)
//                }
//
                if let name = channelNames?["channelName"] as? String {
         
                    let isUnique = !self.channels.contains { channel in//bug fix to stop channel load duplication
                        return channel.channelID == id
                    }
                    if isUnique {
                        self.channels.insert(Channel(channelName: name, channelID: id, mostRecentTimestamp: nil), at: 0)
                    }
                }
                self.channelsTableView.reloadData()
            })
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Guaranteed to use identifier for now.
        
        switch segue.identifier! {
        case "ShowChannel"://existing channels
            if let indexPath = channelsTableView.indexPathForSelectedRow {
                let channel = channels[indexPath.row]
                
                let chatVc = segue.destination as! ChatViewController
                chatVc.channel = channel
                chatVc.channelRef = channelRef.child(channel.channelID!)
                chatVc.senderId = AppDelegate.user.userID
                chatVc.senderDisplayName = AppDelegate.user.username
                
                segue.destination.hidesBottomBarWhenPushed = true
            }
            
        case "NewChannel"://for the new channels created through the text bar 
            
            if let channelName = newChannelTextField?.text, channelName != "" {
                let newChannelRef = channelRef.childByAutoId() //storing channel name on button action to Firebase
                let channelItem = ["channelName": channelName]
                newChannelRef.setValue(channelItem)
                
                let channel = Channel( //json package for firebase
                    channelName: channelName,
                    channelID: newChannelRef.key,
                    mostRecentTimestamp: nil
                )
                
                let chatVc = segue.destination as! ChatViewController//calling next view controller
                chatVc.channel = channel
                chatVc.channelRef = newChannelRef
                chatVc.senderId = AppDelegate.user.userID
                chatVc.senderDisplayName = AppDelegate.user.username
                newChannelTextField.text = "" //set channel back to nil after sergue
                
                segue.destination.hidesBottomBarWhenPushed = true//hide the tab bar
            }
        
        default:
            print("Trying to perform a segue with unknown identifier")//
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
