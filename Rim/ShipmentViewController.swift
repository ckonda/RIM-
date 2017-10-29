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


class ShipmentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    
    var ref: DatabaseReference!
    
    private lazy var Ref: DatabaseReference = Database.database().reference().child("Inventory")
    @IBOutlet weak var itemName: UITextField!

    @IBOutlet weak var numberofItems: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        pickerData = ["Individual", "Dozen", "Sets", "Boxes", "Crates", "Shipments"]
        self.unitPicker.delegate = self
        self.unitPicker.dataSource = self
        
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
    
    var pickerData: [String] = [String]()//loading array of the picker
    
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    
    
    @IBAction func sendButton(_ sender: Any) {
        
        print("SENDD IT")
        addProduct()
        dismiss(animated: true, completion: nil)
        
        
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
