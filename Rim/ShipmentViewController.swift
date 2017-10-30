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


class ShipmentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate{
    
    
    
    var ref: DatabaseReference!
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Inventory")
    @IBOutlet weak var itemName: UITextField!

    @IBOutlet weak var numberofItems: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        

        
        itemName.delegate = self
        numberofItems.delegate = self
        
        numberofItems.keyboardType = UIKeyboardType.numberPad
        
        picturePicker.isUserInteractionEnabled = true
        picturePicker.addGestureRecognizer(tapGestureRecognizer)
        
   
        
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
    
    
    
    @IBOutlet weak var unitPicker: UIPickerView!
    

    
       
    
    
    @IBAction func sendButton(_ sender: Any) {
        addProduct()
       // dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
        
        
    }

    
    
    
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            
            selectedImageFromPicker = editedImage
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker
        {
            picturePicker.image = #imageLiteral(resourceName: "Checkmark")//set image placeholder for after
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

    func addProduct(){
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        
        let profileImage = self.picturePicker.image!
        
        if let uploadData = UIImagePNGRepresentation(profileImage){
            
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let stringDate = dateFormatter.string(from: date)
                    
                    let item = self.itemName.text
                    let amount = self.numberofItems.text
                    
                    let myTeamRef = self.Ref.childByAutoId()
                    
                    let product = [//to make sure the team aligns with each company
                        "profileImageUrl": profileImageUrl,
                        "timestamp": stringDate,
                        "itemName": item!,
                        "amount": amount!,
                        "inventoryID": myTeamRef.key,
                    ] as [String : Any]
                    
                    myTeamRef.setValue(product)

                }
            })
        }
        else {
            print("placement error")
        }
    }
    
    
    
    
    
    


}
