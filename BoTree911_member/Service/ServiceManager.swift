//
//  ServiceManager.swift
//  Botree911_Client
//
//  Created by piyushMac on 06/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ServiceManager {
    
//    MARK:- Helper Method
    func getProjectList(completion: @escaping (_ success: Bool, _ errorMessages: String?, _ jsonData: [Project]?) -> Void) {
        
       do {
            try Alamofire.request(ComunicateService.Router.ProjectList().asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Project List Response: \(json)")
                        
                        if (json.dictionaryObject!["status"] as? Bool)!  && json["data"].count > 0 {
                            let projectList = self.processGetResponceProjectList(json: json["data"])
                            completion(true, nil, projectList)
                        } else {
                            print((json.dictionaryObject!["message"])!)
                            completion(false, (json.dictionaryObject!["message"])! as? String, nil)
                        }
                    }
                case .failure(let error):
                    print(error)
                    completion(false, error.localizedDescription, nil)
                }
            }
        } catch let error{
            print(error)
            completion(false, error.localizedDescription, nil)
        }
    } // End getProjectList()
    
    func processGetResponceProjectList(json: JSON) -> [Project] {
        var projectListSource = [Project]()
        let projects = json["projects"]
        
        for i in 0 ..< projects.count {
            let jsonValue = projects.arrayValue[i]
            let projectDetail = Project(json: jsonValue)
            projectListSource.append(projectDetail)
        }
        return projectListSource
    } // End procssGetResponceProjectList
}
