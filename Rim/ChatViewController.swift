//
//  ChatViewController.swift
//  Rim
//
//  Created by Chatan Konda on 10/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase


class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()//model to load messages in
    
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()//block structure for outgoing bubble
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()//incoming bubble
    
    var channelRef: DatabaseReference?
    var channel: Channel? {
        didSet {
            title = channel?.channelName//set channel to name in previous model cell (clicked on)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] //retrieve message
        if message.senderId == senderId { //if the message was sent by local user send outgoing
            return outgoingBubbleImageView
        } else { //
            return incomingBubbleImageView//else have an incoming bubble appear
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        
        self.senderId = Auth.auth().currentUser?.uid
    }

   
    
    
    
    

   

}
