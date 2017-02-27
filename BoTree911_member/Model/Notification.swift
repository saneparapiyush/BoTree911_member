//
//  Notification.swift
//  Botree911_Client
//
//  Created by piyushMac on 22/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import SwiftyJSON

class Notification {
    var ticket_id: Int?
    var user_name: String?
    var description: String?
    var date: String?
    
    init(json: JSON) {
        ticket_id = json.dictionaryObject!["ticket_id"] as? Int
        user_name = json.dictionaryObject!["user_name"] as? String
        description = json.dictionaryObject!["description"] as? String
        date = json.dictionaryObject!["date"] as? String
    }
}
