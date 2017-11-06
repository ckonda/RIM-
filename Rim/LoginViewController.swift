//
//  ViewController.swift
//  Rim
//
//  Created by Chatan Konda on 9/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

final class LoginViewController: UIViewController , UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailtextField.delegate = self
        passwordtextField.delegate = self

    }
    @IBOutlet weak var emailtextField: UITextField!
    
    @IBOutlet weak var passwordtextField: UITextField!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailtextField.resignFirstResponder()
        passwordtextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailtextField.resignFirstResponder()
        passwordtextField.resignFirstResponder()
        
        return true
        
    }
    
    private func handleLogin() {//log back in using email and password only
    
        var FBRef: DatabaseReference!
        FBRef = Database.database().reference()

        guard let email = emailtextField.text, let password = passwordtextField.text else {
            print("Service Unavailable, Please try again")
            return
            
        }
        
        
        // Force - Unwrapping
        // Force - Casting
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in  //login with email
            
            if user != nil {
                let userID: String = (Auth.auth().currentUser?.uid)!
                
                FBRef.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //I want to make sure that the dictionary is found
                    guard let dict = snapshot.value as? [String: AnyObject] else {
                        print("Error")
                        return
                    }
                    
                    let username = dict["username"] as? String
                    let profileImageUrl = dict["profileImageUrl"] as? String
                    let userID = dict["userID"] as? String
                    let password = dict["password"] as? String
                    let email = dict["email"] as? String
                    let position = dict["position"] as? String
                    let company = dict["company"] as? String


                    
                    AppDelegate.user.initialize(username: username, email: email, password: password, userID: userID, profileImageUrl: profileImageUrl, position: position, company: company)
                    //  UserDefaults.standard.object(forKey: "username") as String? = username
                    self.performSegue(withIdentifier: "gotoMain", sender: self)
                })
            } else {
                //ERROR: catch handle
                print("login error")
            }
        })
        //self.performSegue(withIdentifier: "gotoMain", sender: self)
    }

    @IBAction func loginButton(_ sender: Any) {

        handleLogin()//auth with username and password
        
    }

    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButton(_ sender: Any) {
        
        performSegue(withIdentifier: "gotoRegister", sender: self)
       // dismiss(animated: true, completion: nil)
    }

}
