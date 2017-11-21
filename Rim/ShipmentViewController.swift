//
//  ShipmentViewController.swift
//  Rim
//
//  Created by Chatan Konda on 10/24/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ShipmentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var ref: DatabaseReference!
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Inventory")
    private lazy var activityRef: DatabaseReference = Database.database().reference().child("Activity")
    
    @IBOutlet weak var itemName: UITextField!

    @IBOutlet weak var numberofItems: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var collectionData = ["Units", "Dozen", "Box", "Crate"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var unitType = String()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        self.collectionView.allowsSelection = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
   
        self.collectionView.reloadData()
        
        itemName.delegate = self
        numberofItems.delegate = self
        
        numberofItems.keyboardType = UIKeyboardType.numberPad
        
        picturePicker.isUserInteractionEnabled = true
        picturePicker.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
    
    @IBOutlet weak var picturePicker: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        itemName.resignFirstResponder()
        numberofItems.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemName.resignFirstResponder()
        numberofItems.resignFirstResponder()
        
        return true
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        if let itemName = itemName?.text, let number = numberofItems?.text {
            
            if itemName.characters.count > 0, number.characters.count > 0 {
                addProduct()
                
                navigationController?.popViewController(animated: true)//remove from stack of controllers
            }
        }
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            picturePicker.image = selectedImage//set image placeholder for after
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getCurrentDate() ->  (stringDate: String?, shipDate: String?) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let stringDate = dateFormatter.string(from: date)
        
        let dateOnPicker = self.datePicker.date
        let shipDate = dateFormatter.string(from: dateOnPicker)
    
        return (stringDate, shipDate)
    }

    func addProduct() {
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        
        let profileImage = self.picturePicker.image!
        
        if let uploadData = UIImagePNGRepresentation(profileImage) {
            
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString, let timeStamp = self.getCurrentDate().stringDate,
                    let shipDate = self.getCurrentDate().shipDate, let item = self.itemName.text, let convertedAmount = Int(self.numberofItems.text!) {
    

                    let inventory = self.Ref.childByAutoId()// creating autp id for inventory
                    let activity = self.activityRef.childByAutoId()//creating auto id for activity

                   
                    // JSON Dictionary
                    let product = [//to make sure the team aligns with each company
                        "profileImageUrl": profileImageUrl,
                        "timeStamp": timeStamp,
                        "shipDate": shipDate,
                        "itemName": item,
                        "units": self.unitType,
                        "amount": convertedAmount,
                        "inventoryID": inventory.key,
                        "userID": AppDelegate.user.userID!,
                        "userName": AppDelegate.user.username!,
                        "company": AppDelegate.user.company!
                    ] as [String: Any]
                    
                    inventory.setValue(product)//under auto Id, we will insert JSON to inventory feed
                    activity.setValue(product)//activity Feed
                }
            })
        } else {
            print("placement error")
        }
    }
    
}

extension ShipmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! UnitCell
        
        if let label = cell.viewWithTag(100) as? UILabel {
            
            label.text = collectionData[indexPath.row]
        }
        
        if indexPath.row == 0 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            cell.layer.borderColor = UIColor.gray.cgColor
        } else {
            
            cell.layer.borderColor = UIColor.white.cgColor
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.collectionView.cellForItem(at: indexPath) as! UnitCell
        
        if cell.isSelected {
            cell.layer.borderColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
            cell.layer.borderWidth = 1
            
            switch indexPath.row {
            case 0:
                 unitType = collectionData[0]
                print(unitType)
            case 1:
                 unitType = collectionData[1]
                 print(unitType)
            case 2:
                 unitType = collectionData[2]
                 print(unitType)
            case 3:
                 unitType = collectionData[3]
                 print(unitType)
            default:
                print("nothing selected yet")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = self.collectionView.cellForItem(at: indexPath) as! UnitCell
        
        cell.layer.borderColor = UIColor.white.cgColor
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}
