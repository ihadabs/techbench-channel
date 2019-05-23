//
//  Message.swift
//  TechBenchChannel
//
//  Created by Hadi Albinsaad on 10/11/2018.
//  Copyright © 2018 Hadi. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Message {
    
    let sender: String
    let text: String
    let timestamp: Timestamp
    
    var dictionary: [String: Any] {
        return [
            "sender" : sender,
            "text": text,
            "timestamp": timestamp
        ]
    }
    
}

extension Message {
    
    init?(dictionary: [String: Any]) {
        guard let sender = dictionary["sender"] as? String,
            let text = dictionary["text"] as? String,
            let timestamp = dictionary["timestamp"] as? Timestamp
        else {
            return nil
        }
        
        self.init(sender: sender, text: text, timestamp: timestamp)
    }
}
