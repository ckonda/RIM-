//
//  MyTeamViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/20/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var teamModel = [MyTeam]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        observeData()
        
    }
    
    
    
    func observeData() {
        ref = Database.database().reference().child("myTeam")
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0 {
                self.teamModel.removeAll()
                for teams in snapshot.children.allObjects as![DataSnapshot] {
                    
                    guard let team = teams.value as? [String: AnyObject] else {
                        print("contains no team data")
                        return
                    }
                    
                    let company = team["company"] as! String?
                    
                    let teamObject = MyTeam(username: team["username"] as! String?,
                                            email: team["email"] as! String?,
                                            password: nil,
                                            userID: team["userID"] as! String?,
                                            profileImageUrl: team["profileImageUrl"] as! String?,
                                            position: team["position"] as! String?,
                                            company: company)
                    
                    if AppDelegate.user.company == company {//checks if it is the same company
                        self.teamModel.insert(teamObject, at: 0)
                    }
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! MyTeamCell
        
        let team = teamModel[indexPath.row]
        
        cell.name.text = team.username
        cell.position.text = team.position
        
        if let profileImage = team.profileImageUrl {
            
            cell.profileImage.loadImageUsingCacheWithUrlString(urlString: profileImage)

        }
    
        return cell
    }
    
}
