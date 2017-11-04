//
//  Channel.swift
//  Rim
//
//  Created by Chatan Konda on 10/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation

class Channel: NSObject {
    var channelName: String?
    var channelID: String?
    var mostRecentTimestamp: String?
    
    init(channelID: String, channelName: String?, latestMessageTimeStamp: String?) {
        self.channelName = channelName
        self.channelID = channelID

        self.mostRecentTimestamp = latestMessageTimeStamp
    }
    
}
