//
//  ChatVC.swift
//  MsgApp
//
//  Created by Asgedom Yohannes on 11/27/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    public init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView : UITableView!
    
    var messageDetail = [MessageDetail]()
    var detail: MessageDetail
    var currentUser = KeychainWrapper.standard.string(forKey:"uid")
    var recipient: String!
    var messageId : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("users").child(currentUser!).child("messages").observe(.value, with:{(snapShot)in
            if let snapshot = snapShot.children.allObjects as? [DataSnapshot]{
                self.messageDetail.removeAll()
                for data in snapshot {
                    if let messageDict = data.value as? Dictionary<String,AnyObject> {
                        let key = data.key
                        let info = messageDetail(messageKey:key ,messaageData: messageDict)
                        
                        self .messageDetail.append(info)
                    }
                }
            }
            
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messageDet = messageDetail[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as? MessageDetailCell{
            cell.configerCell(messageDetail: messageDet)
            return cell
        }else{
            return MessageDetailCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipient = messageDetail[indexPath.row].recipient
        messageId = messageDetail[indexPath.row].messageRef.key
        performSegue(withIdentifier: "tomessages", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MessageVC{
            destinationViewController.recipient = recipient
            destinationViewController.messageId = messageId
        }
        
    }
    @IBAction func signOut(_ sender: Any) {
        
        try! Auth.auth().signOut()
        KeychainWrapper.standard.removeObject(forKey: "uid")
        dismiss(animated: true, completion: nil)
    }
}
