//
//  ActivityCommentController.swift
//  Rim
//
//  Created by Luis Mejia on 11/2/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ActivityCommentController: UITableViewController {

    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var activityImage: UIImageView!

    @IBOutlet weak var userTeamName: UILabel!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    var commentsArr = [ActivityComment]()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    var activity_comments = [ActivityComment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("Comments")
        observeComments()
    }
    @IBAction func addComment(_ sender: Any) {
        let commentAlert = UIAlertController(title: "New Comment", message:"Enter Your Comment", preferredStyle: .alert)
        
        commentAlert.addTextField {(textField: UITextField!) -> Void in textField.placeholder =  "Comment..."}
        
        commentAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action:UIAlertAction) in
            if let commentContent = commentAlert.textFields?.first?.text{
                let comment = ActivityComment(content: commentContent, username: Firebase.Auth.auth().currentUser!.uid)
                let commentReference = self.databaseRef.child(commentContent.lowercased())
                commentReference.setValue(comment.toAnyObject())
            }
        }))
        
        self.present(commentAlert, animated:true, completion: nil)
        
    }
    
    
    func observeComments()
    {
        databaseRef.observe(.value, with: { (snapshot: DataSnapshot) in
            var newComments = [ActivityComment]()
            for comment in snapshot.children
            {
                let commentObject = ActivityComment(snapshot:comment as! DataSnapshot)
                newComments.append(commentObject)
            }
            self.activity_comments = newComments
            self.tableView.reloadData()
        })
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activity_comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! ActivityCommentCell

        // Configure the cell...
        let comment = activity_comments[indexPath.row]
        cell.textLabel?.text = comment.content
        cell.detailTextLabel?.text = comment.username
        return cell
    }
 
}
