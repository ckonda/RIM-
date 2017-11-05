//
//  Channel.swift
//  Rim
//
//  Created by Chatan Konda on 10/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

class Channel: NSObject{
    var channelName: String?
    var channelID:String?
    var mostRecentTimestamp: String?
    
    init(channelID: String, channelName: String?, latestMessageTimeStamp: String?){
        self.channelName = channelName
        self.channelID = channelID

        self.mostRecentTimestamp = latestMessageTimeStamp
    }
}


//internal class Channel {
//    internal let id: String
//    internal let name: String
//    
//    init(id: String, name: String) {
//        self.id = id
//        self.name = name
//    }
//}
