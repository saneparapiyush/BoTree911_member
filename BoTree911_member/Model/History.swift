//
//  History.swift
//  Botree911_Client
//
//  Created by piyushMac on 08/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import SwiftyJSON

class History {
    var id: Int?
    var user_name: String?
    var last_status: String?
    var current_status: String?
    var date_time: String?
    
    init(json: JSON) {
        id = json.dictionaryObject!["id"] as? Int
        user_name = json.dictionaryObject!["user_name"] as? String
        last_status = json.dictionaryObject!["last_status"] as? String
        current_status = json.dictionaryObject!["current_status"] as? String
        date_time = json.dictionaryObject!["date_time"] as? String
    }
}
