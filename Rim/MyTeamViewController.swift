//
//  myTeamViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/20/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var teamModel = [myTeam]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference().child("myTeam");
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0 {
                self.teamModel.removeAll()
                for teams in snapshot.children.allObjects as![DataSnapshot]{
                    let team = teams.value as? [String: AnyObject]
                    let name = team?["username"] as! String?
                    let position = team?["position"] as! String?
                    let teamImage = team?["profileImageUrl"] as! String?
                    let userID = team?["userID"] as! String?
                    let email = team?["email"] as! String?
                    let company = team?["company"] as! String?
                    
                    let teamObject = myTeam(username: name, email: email, userID: userID, profileImageUrl: teamImage, position: position, company: company)
                    
                    if AppDelegate.user.company == company{//checks if it is the same company
                        self.teamModel.insert(teamObject, at: 0)
                    }
                    
                    //self.teamModel.insert(teamObject, at: 0)
                    
                }
                self.tableView.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! myTeamCell
        
        let team = teamModel[indexPath.row]
        
        cell.name.text = team.username
        cell.position.text = team.position
        
        if let profileImage = team.profileImageUrl {
            
            cell.profileImage.loadImageUsingCacheWithUrlString(urlString: profileImage)

        }
    
        return cell
    }
    
}
