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

class InventoryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
  
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    
    var inventModel = [Inventory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        observechannels()//pull channel data from the inventory feed
        
    

    }
    
    
    
    func observechannels(){
    
        ref = Database.database().reference().child("Inventory")
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount>0{
                self.inventModel.removeAll()
                
//                for inventory in snapshot.children.allObjects as! [DataSnapshot]{
//                    
//                    let feed = inventory.value as? [String: AnyObject]
//                    
//                    
//             
//                    
//                    
//                    
//                    
//                    
//                }
            }
            
            
            
        })

        
    
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        
        let inventory = inventModel[indexPath.row]
        
        
        
        
        cell.inventoryName.text = "Hello World"
        
        
        return cell
        
        
    }
    
    @IBAction func formButton(_ sender: Any) {//sell action
        
        performSegue(withIdentifier: "soldForm", sender: self)
        
    }
    
    
    
    @IBAction func shipForm(_ sender: Any) {
        
        performSegue(withIdentifier: "shipForm", sender: self)
    }
    
    
    
    
    
    
    

  

}
