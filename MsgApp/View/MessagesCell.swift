//
//  MessagesCell.swift
//  MsgApp
//
//  Created by Asgedom Yohannes on 11/28/18.
//  Copyright © 2018 Asgedom Yohannes. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var recievedMessageLbl: UILabel!
    @IBOutlet weak var recievedMessageView: UIView!
    @IBOutlet weak var sentMessageLbl: UILabel!
    @IBOutlet weak var sentMessageView: UIView!
    
    
    var message: Message!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell (message: Message){
        self.message = message
        if message.sender == currentUser{
            sentMessageView.isHidden = false
            sentMessageLbl.text = message.message
            recievedMessageLbl.isHidden = true
            recievedMessageLbl.text = ""
            
        }else {
            sentMessageView.isHidden = true
            sentMessageLbl.text = ""
            recievedMessageLbl.isHidden = false
            recievedMessageLbl.text = message.message
            
        }
    }

}
