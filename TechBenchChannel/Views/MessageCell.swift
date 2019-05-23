//
//  MessageCell.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 10/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import UIKit
import FirebaseAuth


class MessageCell: UITableViewCell {
    
    @IBOutlet weak var textLb: UILabel!
    @IBOutlet weak var senderLb: UILabel!
    @IBOutlet weak var timestampLb: UILabel!
    
    var message: Message? {
        didSet {
            textLb.text = message?.text
            timestampLb.text = getDate(date: message!.timestamp.dateValue())
            senderLb.text = (message?.sender == Auth.auth().currentUser?.email) ? "You" : message?.sender
        }
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM hh:mm:ss"
        return dateFormatter.string(from: date)
    }
}
