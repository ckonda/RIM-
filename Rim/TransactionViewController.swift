//
//  TransactionViewController.swift
//  Rim
//
//  Created by Chatan Konda on 10/24/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase

class TransactionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var productName: UITextView!

    @IBOutlet weak var productAmount: UITextView!
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Inventory")
    
    @IBAction func sendButton(_ sender: Any) {
        
        if let itemName = productName?.text, let number = productAmount?.text {
            
            if itemName.count > 0, number.count > 0 {
                deletePost()
                print("Transaction in progress")
                
                navigationController?.popViewController(animated: true)//remove from stack of controllers
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        productName.resignFirstResponder()
        productAmount.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        productName.resignFirstResponder()
        productAmount.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productName.layer.borderColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        productName.layer.borderWidth = 1.0
        productName.layer.cornerRadius = 5
        
        productAmount.layer.borderColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        productAmount.layer.borderWidth = 1.0
        productAmount.layer.cornerRadius = 5
        
    }
    
    func deletePost() {
        Ref.observe(DataEventType.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                print("Error")
                return
            }
            let id = snapshot.key
            
            guard let amount = dict["amount"] as? Int else {
                print("Could not cast amount form dictionary")
                return
            }
            
            guard let itemName = dict["itemName"] as? String else {
                print("Could not cast itemName form dictionary")
                return
            }
            
            guard let intAmount = Int(self.productAmount.text) else {
                print("Textfield probably doesn't have anything")
                return
            }
            
            if itemName.lowercased() == self.productName.text.lowercased() {
                let IntFirAmount = Int(amount)
                if intAmount >= IntFirAmount {
                    self.Ref.child(id).removeValue()
                } else {
                    let newAmount = IntFirAmount - intAmount
                    self.Ref.child(id).updateChildValues(["amount": newAmount])
                }
            }

        })
    }
}
