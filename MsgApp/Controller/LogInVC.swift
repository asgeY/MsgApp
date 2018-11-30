//
//  ViewController.swift
//  MsgApp
//
//  Created by Asgedom Yohannes on 11/23/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LogInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            self.performSegue(withIdentifier: "ToMessges", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSignUp"{
            if let destination = segue.destination as? SignUpVC {
                if self.userId != nil{
                destination.userId = userId
                }
                if self.emailField.text != nil {
                    destination.emailField = emailField.text
                }
                if self .passwordField.text != nil{
                    destination.passwordField = passwordField.text
                }
            }
        }
    }
    @IBAction func SignIn(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email,password: password, completion:{(user,error) in
                if error == nil {
                    self.userId = user!.user.uid
                    KeychainWrapper.standard.set(self.userId, forKey: "uid")
                    
                    self.performSegue(withIdentifier: "ToMessges", sender: nil)
                    
                }else{
                    self.performSegue(withIdentifier: "SignUp", sender: nil)
                }
            })
        }
    }
}

