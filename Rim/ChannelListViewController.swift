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
//    enum Section: Int {//to hold the different tableview sections
//        case createNewChannelSection = 0
//        case currentChannelsSection
//    }
//    
    var senderDisplayName: String? // Person sending chat info

    private var channels: [Channel] = [] //holding for channels model data
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("Channels")
    private var channelRefHandle: DatabaseHandle?

    @IBOutlet weak var channelsTableView: UITableView!//ref for the channels tableview
    
    @IBOutlet weak var newChannelTextField: UITextField!//new channel text input
    
    @IBAction func createChannelButton(_ sender: Any) {
          performSegue(withIdentifier: "NewChannel", sender: self)
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
        
//        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
//            if let createNewChannelCell = cell as? CreateChannelCell {
//                
//                    newChannelTextField = createNewChannelCell.newChannelNameField//setting newly created channel from ChannelCell to the text field
//                
//            }
//        } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
        
            if let channelCell = cell as? ChannelCell {
                
           //     let channel = channels[indexPath.row]
                
                channelCell.channelName.text = channels[indexPath.row].channelName
                
                channelCell.timeStamp.text = "Just Now"
                
                //let timeQuery = Database.database().reference().child("Channels")//.child(channel.channelID!)//.child("messages").queryLimited(toLast: 1)
                
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
       // }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = channels[indexPath.row]
        self.performSegue(withIdentifier: "ShowChannel", sender: message)
        channelsTableView.deselectRow(at: indexPath, animated: true)
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
                self.channelsTableView.reloadData()
            })
        })
    }
  //  @IBAction func createChannel(_ sender: Any) {
        
//        performSegue(withIdentifier: "ShowChannel", sender: self)
 //   }
    
       // if let name = newChannelTextField?.text { //
            
         //   if name.characters.count > 0 {//nil checker
 
           //     let newChannelRef = channelRef.childByAutoId() //storing channel name on button action to Firebase
             //   let channelItem = [
               //     "channelName": name
                //]
                //newChannelRef.setValue(channelItem)
                
//              //  if let createCell = sender as? CreateChannelCell {
//                    
//                   // let channel = sender as! Channel
//                    let chatvc = ChatViewController()
//                    
//                    chatvc.senderDisplayName = AppDelegate.user.username
//                    chatvc.senderId = AppDelegate.user.userID
//                    chatvc.channelName = name
//                    chatvc.channelRef = channelRef.child(newChannelRef.key)
//                    
//               //     createCell.delegate.callSegueFromCell(myData: mydata as AnyObject)
//                    self.performSegue(withIdentifier: "ShowChannel", sender: self)
              //  }
                
     //       }
      //  }
   // }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Guaranteed to use identifier for now.
        switch segue.identifier! {
        case "ShowChannel":
            if let indexPath = channelsTableView.indexPathForSelectedRow {
                let channel = channels[indexPath.row]
                
                let chatVc = segue.destination as! ChatViewController
                chatVc.channel = channel
                chatVc.channelRef = channelRef.child(channel.channelID!)
                chatVc.senderId = AppDelegate.user.userID
                chatVc.senderDisplayName = AppDelegate.user.username
                
                segue.destination.hidesBottomBarWhenPushed = true
            }
            
        case "NewChannel":
            
            if let channelName = newChannelTextField?.text, channelName != "" {
                let newChannelRef = channelRef.childByAutoId() //storing channel name on button action to Firebase
                let channelItem = ["channelName": channelName]
                newChannelRef.setValue(channelItem)
                
                let channel = Channel(
                    channelID: newChannelRef.key,
                    channelName: channelName,
                    latestMessageTimeStamp: nil
                )
                
                let chatVc = segue.destination as! ChatViewController
                chatVc.channel = channel
                chatVc.channelRef = newChannelRef
                chatVc.senderId = AppDelegate.user.userID
                chatVc.senderDisplayName = AppDelegate.user.username
                
                segue.destination.hidesBottomBarWhenPushed = true
            }
        
        default:
            print("Trying to perform a segue with unknown identifier")
        }
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
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
