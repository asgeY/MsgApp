//
//  SignUpVC.swift
//  MsgApp
//
//  Created by Asgedom Yohannes on 11/26/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var SignUpBtn: UIButton!
    
    var userId: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageselected = false
    var userName: String!
    
    //Do any Additional SetUp after  loading the view
    override func viewDidLoad() {
        super .viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: "uid") {
            performSegue(withIdentifier: "ToMessges", sender: nil)
            }
        }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImagePicker.image = image
            imageselected = true
        }else{
            print("Image wasent selected!")
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    func setuser(img: String){
        let userData = [
            "username": userName!,"userimage": img]
        KeychainWrapper.standard.set(userId, forKey: "uid")
        let location = Database.database().reference().child("users").child(userId)
        location.setValue(userData)
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImg (){
        if userNameField.text == nil {
            SignUpBtn.isEnabled = false
            
        }else {
            userName = userNameField.text
            SignUpBtn.isEnabled = true
        }
        
        guard let img = userImagePicker.image, imageselected == true else {
            print("Image needs to be selected")
            
            return
        }
        
        if let imgData = img.jpegData(compressionQuality: 0.2) {
            
            let imgUid = NSUUID().uuidString
            let storageRef = StorageMetadata()
            storageRef.contentType = "image/Jpeg"
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: nil, completion: {(metaData,error
                ) in
                
                if error != nil {
                print("Did not upload Image!")
                    
            }else {
                   print("Uploaded")
                    
                    let downloadURL = storageRef.downloadURL()? .absoulteString
                    
                    if let url = downloadURL {
                        self.setUser(img:url)
                    }
                }
            })
        }
    }
    
    @IBAction func createAccount (_sender: AnyObject){
        Auth.auth().createUser(withEmail: emailField,password: passwordField,completion: {(user,error) in
            if error != nil {

                    print("Can't create User!")
                
            }else{
                if let user = user {
                    self.userId = user.user.uid
                }
            }
            self.uploadImg()
        })
    }
    
    @IBAction func selectedImgPicker(_sender: AnyObject){
        
            present(imagePicker,animated: true,completion: nil)
        
        }
    
    @IBAction func cancel(_sender: AnyObject){
        
            dismiss(animated: true, completion: nil)
        }
    }

