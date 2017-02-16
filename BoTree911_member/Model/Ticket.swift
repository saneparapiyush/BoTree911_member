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
    var updated_at: String?
    var raised_by: String?
    var assingee: String?
    
    init(json: JSON) {
        id = json.dictionaryObject!["id"] as? Int
        project_id = json.dictionaryObject!["project_id"] as? Int
        name = json.dictionaryObject!["name"] as? String
        description = json.dictionaryObject!["description"] as? String
        status = json.dictionaryObject!["status"] as? String
        updated_at = json.dictionaryObject!["updated_at"] as? String
        raised_by = json.dictionaryObject!["raised_by"] as? String
        
        if ((json.dictionaryObject!["assingee"] as? String) != nil) {
            assingee = json.dictionaryObject!["assingee"] as? String
        } else {
            assingee = "Pending..."
        }
        
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
