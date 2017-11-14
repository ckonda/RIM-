//  ActivityComment.swift
//  Rim
//  Created by Luis Mejia on 11/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

//:: Activity Comment help: https://www.youtube.com/watch?v=aPgZI3KP0iQ
struct ActivityComment
{
    var userImageUrl: String!
    var commentId: String!
    var content: String!
    var username: String!
    var ref: DatabaseReference?
    var key: String!
    
    init(content: String, username: String, key: String = "")
    {
        self.content = content
        self.username = username
        self.key = key
        self.ref = nil
    }
    
    init(commentId: String, userImageUrl: String, content: String, username: String, key: String = "")
    {
        
        self.commentId = commentId
        self.userImageUrl = userImageUrl
        self.content = content
        self.username = username
        self.key = key
        self.ref = Database.database().reference()
    }
    
    init(snapshot: DataSnapshot)
    {
        //:: Fixed issue: https://stackoverflow.com/questions/39480150/type-any-has-no-subscript-members-after-updating-to-swift-3
        let snapShotValue = snapshot.value as? NSDictionary
        self.content = snapShotValue!["content"] as? String
//        self.commentId = snapShotValue!["commentId"] as? String
        self.username = snapShotValue!["username"] as? String
        self.key = snapshot.key
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject
    {
        return ["content": content,  "username":username] as NSDictionary
    }
}
