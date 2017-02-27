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
    var date_time: String?
    var body: String?
    
    init(json: JSON,bodyData: String) {
        id = json.dictionaryObject!["id"] as? Int
        user_name = json.dictionaryObject!["user_name"] as? String
        date_time = json.dictionaryObject!["date_time"] as? String
        body = bodyData
    }
}
