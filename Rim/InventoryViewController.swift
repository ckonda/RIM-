//
//  InventoryViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/27/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Inventory")
    
    var inventModel = [Inventory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        observechannels()//pull channel data from the inventory feed
        self.tableView.reloadData()
        
    }
    
    func observechannels() {
        
        Ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0 {
                self.inventModel.removeAll()
                
                guard let retrievedObjects = snapshot.children.allObjects as? [DataSnapshot] else {
                    print("Could not retrieve objects")
                    return
                }
                
                for inventory in retrievedObjects {
                    guard let feed = inventory.value as? [String: AnyObject] else {
                        print("Failed to cast inventory as dictionary")
                        return
                    }
                    
                    let object = Inventory(
                        username: feed["username"] as? String,
                        profileImageUrl: feed["profileImageUrl"] as? String,
                        timeStamp: feed["timestamp"] as? String,
                        item_name: feed["itemName"] as? String,
                        inventoryID: feed["inventoryID"] as? String,
                        amount: feed["amount"] as? Int,
                        userID: feed["userID"] as? String,
                        shipDate: feed["shipdate"] as? String,
                        units: feed["units"] as? String,
                        company: feed["company"] as? String
                    )
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let current = dateFormatter.string(from: date)
                    dateFormatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
                    let currentDate = dateFormatter.date(from: current)
                    
                    guard let shippingDate = object.shipDate else {
                        print("Failed to find a ship date from object")
                        return
                    }
                    
                    guard let company = object.company else {
                        print("There is no company")
                        return
                    }
                    if AppDelegate.user.company == company {
                        let formattedShippingDate = dateFormatter.date(from: shippingDate)
                        if currentDate! >= formattedShippingDate! {
                            self.inventModel.insert(object, at: 0)
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
                
//                for inventory in snapshot.children.allObjects as! [DataSnapshot] {
//
//                    let feed = inventory.value as? [String: AnyObject]
//                    let profileImageUrl = feed?["profileImageUrl"] as! String?
//                    let timestamp = feed?["timestamp"] as! String?
//                    let shipDate = feed?["shipdate"] as! String?
//                    let itemName = feed?["itemName"] as! String?
//                    let units = feed?["units"] as! String?
//                    let amount = feed?["amount"] as! Int
//                    let inventoryID = feed?["inventoryID"] as! String?
//                    let userID = feed?["userID"] as! String?
//                    let username = feed?["username"] as! String?
//                    let company = feed?["company"] as! String?
                    
                    //something wrong with translation
                    
//                    let date = Date()
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
//                    let current = dateFormatter.string(from: date)
//                    dateFormatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
//                    let currentDate = dateFormatter.date(from: current)
//
//                    let shippingDate = dateFormatter.date(from: shipDate!)
//                    
//                    let productObject = Inventory(username: username, profileImageUrl: profileImageUrl, timeStamp: timestamp, item_name: itemName, inventoryID: inventoryID, amount: amount, userID: userID, shipDate: shipDate, units: units, company: company)
//                    
//                    if AppDelegate.user.company == company, shippingDate! <= currentDate! {
//                        
//                        self.inventModel.insert(productObject, at: 0)
//                        
//                    }
                    
//                }
//                        self.tableView.reloadData()
//            }
//        })
    
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        
        let inventory = inventModel[indexPath.row]
        
        cell.inventoryName.text = inventory.item_name
        cell.units.text = inventory.units
        cell.timeStamp.text = inventory.timeStamp
        cell.amount.text = String(describing: inventory.amount!)

        if let Image = inventory.profileImageUrl {
            cell.productPic.loadImageUsingCacheWithUrlString(urlString: Image)
        }
        
        return cell
        
    }
    
    @IBAction func formButton(_ sender: Any) {//sell action
        
        performSegue(withIdentifier: "soldForm", sender: self)
        
    }
    
    @IBAction func shipForm(_ sender: Any) {
        
        performSegue(withIdentifier: "shipForm", sender: self)
    }
    
}
