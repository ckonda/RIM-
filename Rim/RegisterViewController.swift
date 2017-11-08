//
//  registerViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/18/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        jobTextField.delegate = self
        companyTextField.delegate = self

    }
    
    @IBOutlet weak var jobTextField: UITextField!//position
    @IBOutlet weak var companyTextField: UITextField!

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        jobTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        jobTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
        
        return true
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
            profilePicture.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        print("reached")
        handleRegister()//register and authenticate
    }
    
    func registerUserintoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        
        let ref = Database.database().reference()
        let usersReference  = ref.child("Users").child(uid)//create auto ID for child
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, _) in//second part of closure is "ref"
            if err != nil {
                print(err!)
                return
            }
            let user = User()//this setter crashes if keys dont match
            //  AppDelegate.user.initialize(username: nil, email: self.emailtextField.text, password: self.passwordtextField.text, userID: uid)
            AppDelegate.user.setValuesForKeys(values)//obsolete
            user.setValuesForKeys(values)
            self.performSegue(withIdentifier: "gotoHome", sender: self)
        })
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let position = jobTextField.text, let company = companyTextField.text else {
            
            print("Service Unavailable, Please try again")
            return//if all fields not filled out completely, logout
        }
        //firebase authtification access( if not authenticated then throw error)
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            guard let uid = user?.uid else {
                return
            }
            // if user != nil {
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png")
            
            let profileImage = self.profilePicture.image!
            
            if let uploadData = UIImagePNGRepresentation(profileImage) {
                
                storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["username": name, "email": email, "password": password, "userID": uid, "profileImageUrl": profileImageUrl, "position": position, "company": company]
                        
                        AppDelegate.user.initialize(username: name, email: self.emailTextField.text, password: self.passwordTextField.text, userID: uid, profileImageUrl: profileImageUrl, position: position, company: company)
                        
                        let MyTeamRef = self.ref.child("MyTeam").child(uid)
                        
                        let teamJSON = [//to make sure the team aligns with each company
                            "position": position,
                            "profileImageUrl": profileImageUrl,
                            "company": company,
                            "username": name,
                            "userID": uid,
                            "email": email
                        ]
                        MyTeamRef.setValue(teamJSON)
                        
                        self.registerUserintoDatabaseWithUID(uid: uid, values: values as [String: AnyObject])
                    }
                    
                })
                //  AppDelegate.user.initialize(username: nil, email: self.emailtextField.text, password: self.passwordtextField.text, userID: uid, profileImageURL: profileImageUrl )
            } else {
                print("register error")
                //Error: check error
            }
            //user has been authenticated
        })
    }
}
