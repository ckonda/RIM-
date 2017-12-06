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

class InventoryViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Inventory")
    
    var inventModel = [Inventory]()
    var filteredData = [Inventory]()
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        self.hideKeyboardWhenTappedAround()
        
        searchBar.placeholder = "Search"
        
        tableView.delegate = self
        tableView.dataSource = self
        observechannels()//pull channel data from the inventory feed
        self.tableView.reloadData()
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    /**
     Initalizes our observing of channels
    */
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
                    
                    let object = Inventory(profileImageURL: feed["profileImageUrl"] as? String,
                                        shipmentSentUsername: feed["username"] as? String,
                                        timeStamp: feed["timestamp"] as? String,
                                        shipDate: feed["shipDate"] as? String,
                                        itemName: feed["itemName"] as? String,
                                        unitType: feed["units"] as? String,
                                        quantity: feed["amount"] as? Int,
                                        userID: feed["userID"] as? String,
                                        productID: feed["inventoryID"] as? String,
                                        company: feed["company"] as? String)
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let current = dateFormatter.string(from: date)//current timestamp string
                    
                    dateFormatter.timeZone = NSTimeZone(abbreviation: "PT+0:00") as TimeZone!
                    let currentDate = dateFormatter.date(from: current)//back to date
                    
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
    
    @IBAction func formButton(_ sender: Any) {//sell action
        
        performSegue(withIdentifier: "soldForm", sender: self)//segue to the sold form
        
    }
    
    @IBAction func shipForm(_ sender: Any) {
        
        performSegue(withIdentifier: "shipForm", sender: self)//segue to the shipment form
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {//search to conform to the filtered data inventory model
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false//if text is empty then return the search bar

            view.endEditing(true)
            print ("working")
            tableView.reloadData()
        } else {
            isSearching = true//if searching is returned, search for the product name in tableview
            filteredData = inventModel.filter({($0.itemName?.localizedCaseInsensitiveContains(searchBar.text!))!})
            tableView.reloadData()
        }
    }
}
extension InventoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        }
        return inventModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//deselect te row once selected, maybe segue in future?
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        
        //implement of search bar filtration
        let product: Inventory// to conform cell for at to the isSearching
        if isSearching {
            print("\(filteredData.count)")
            product = filteredData[indexPath.row]
            
            cell.inventoryName.text = product.itemName
            cell.amount.text = String(describing: product.quantity!)
            cell.units.text = product.unitType
            cell.timeStamp.text = product.timeStamp
        } else {
            print("\(filteredData.count)")
            product = inventModel[indexPath.row]
            cell.inventoryName.text = product.itemName
            cell.amount.text = String(describing: product.quantity!)
            cell.units.text = product.unitType
            cell.timeStamp.text = product.timeStamp
            
//            job = jobData[indexPath.row]
//            cell.postLabel.text = job.jobName
//            cell.postPrice.text = String(describing: job.price!)
//            cell.locationLabel.text = job.location
        }
        
        if let Image = product.profileImageURL {
            
            cell.productPic.loadImageUsingCacheWithUrlString(urlString: Image)
        }
        return cell
    }
}
