//
//  Comment.swift
//  Botree911_Client
//
//  Created by piyushMac on 08/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import SwiftyJSON

class Comment {
    var id: Int?
    var user_name: String?
    var comment: String?
    var date_time: String?
    
    init(json: JSON) {
        id = json.dictionaryObject!["id"] as? Int
        user_name = json.dictionaryObject!["user_name"] as? String
        comment = json.dictionaryObject!["comment"] as? String
        date_time = json.dictionaryObject!["date_time"] as? String        
    }
}

