//
//  Ticket.swift
//  Botree911_Client
//
//  Created by piyushMac on 03/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import SwiftyJSON

class Ticket {
    var id: Int?
    var project_id: Int?
    var name: String?
    var description: String?
    var status: String?
    var created_at: String?
    var raised_by: String?
    var assingee: String?
    var comment_count: Int?
    var history_count: Int?
    
    init(json: JSON) {
        id = json.dictionaryObject!["id"] as? Int
        project_id = json.dictionaryObject!["project_id"] as? Int
        name = json.dictionaryObject!["name"] as? String
        description = json.dictionaryObject!["description"] as? String
        status = json.dictionaryObject!["status"] as? String
        created_at = json.dictionaryObject!["created_at"] as? String
        raised_by = json.dictionaryObject!["raised_by"] as? String
        
//        if ((json.dictionaryObject!["assingee"] as? String) != nil) {
//            assingee = json.dictionaryObject!["assingee"] as? String
//        } else {
//            assingee = "Pending..."
//        }
        
        ((json.dictionaryObject!["assingee"] as? String) != nil) ? (assingee = json.dictionaryObject!["assingee"] as? String) : (assingee = "Pending...")
        
        comment_count = json.dictionaryObject!["comment_count"] as? Int
        history_count = json.dictionaryObject!["history_count"] as? Int
    }
}

class TicketStatus {
    var ticket_status_name: String?
    var status_value : Int?
    
    init(json: JSON) {
        ticket_status_name = json.dictionaryObject!["name"] as? String
        status_value = json.dictionaryObject!["value"] as? Int
        
    }
}
