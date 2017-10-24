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
            
            if let channelCell = cell as? ChannelCell{
                channelCell.channelName.text = channels[(indexPath as NSIndexPath).row].channelName
                
            }
            
   
        }
        return cell
    }
    
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(DataEventType.childAdded, with: { (snapshot) in
            let id = snapshot.key
            let newRef = snapshot.ref

            newRef.observe(DataEventType.value, with: { (snapshot) in
                
                let channelNames = snapshot.value as? [String: AnyObject]
                
                if let name = channelNames?["channelName"] as! String!{
                    
                    print(name)
                    
                    self.channels.insert(Channel(channelID: id, channelName: name, latestMessageTimeStamp: nil), at: 0)
                    self.tableView.reloadData()
                    
                }
                self.tableView.reloadData()
                
            })
            
            self.tableView.reloadData()
            
        })
    }
    
    
    @IBAction func createChannel(_ sender: Any) {
        
        if let name = newChannelTextField?.text { //
            let newChannelRef = channelRef.childByAutoId() //storing channel name on button action to Firebase
            let channelItem = [
                "channelName": name
            ]
            newChannelRef.setValue(channelItem)
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        
        if (segue.identifier == "ShowChannel") {
            if let channel = sender as? Channel{
                
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
       // title = "El Dios"
        observeChannels()
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    

  

   
    
    
    

}
