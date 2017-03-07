//
//  NotificationViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 22/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import Alamofire
import FTProgressIndicator
import SwiftyJSON
import Toast

class NotificationViewController: AbstractViewController {
    
    @IBOutlet var tblNotificationList: UITableView!
    
    var notificationListSource = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = getLocalizedString("title_notification")
        
    } // End viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        //            MARK: OFLINE
        getNotificationList()
//                setOflineDataSource()
        //            MARK: END OFLINE
        
    }//End viewWillAppear()
    
    
    //    MARK:- Helper Method
    func getNotificationList() {
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("notification_list_indicator"), userInteractionEnable: false)
        do {
            try Alamofire.request(ComunicateService.Router.NotificationList().asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Notification List Response: \(json)")
                        
                        if (json.dictionaryObject!["status"] as? Bool)! && json["data"]["notifications"].count > 0 {
                            self.processGetResponceNotificationList(json: json["data"], completionHandler: {
                                self.dismissIndicator()
                            })
                        } else {
                            self.view.makeToast("\((json.dictionaryObject!["message"])!)")
                        }
                        self.dismissIndicator()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.view.makeToast(error.localizedDescription)
                }
            }
        } catch let error{
            print(error)
            self.dismissIndicator()
            self.view.makeToast(error.localizedDescription)
        }
    } // End getNotificationList()
    
    func processGetResponceNotificationList(json: JSON, completionHandler: () -> Void) {
        notificationListSource = [Notification]()
        let notification = json["notifications"]
        
        for i in 0 ..< notification.count {
            let jsonValue = notification.arrayValue[i]
            let notificationDetail = Notification(json: jsonValue)
            notificationListSource.append(notificationDetail)
        }
        tblNotificationList.reloadData()
        
        completionHandler()
    }// End processGetResponceNotificationList
}

extension NotificationViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotificationList.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        
        cell.notification = notificationListSource[indexPath.row]
        cell.setNotificationListData()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

class NotificationCell: UITableViewCell {
    var notification: Notification?
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblNotificationDate: UILabel!
    
    func setNotificationListData() {
        
        lblUserName.text = notification?.user_name
        lblDescription.text = notification?.description
        lblNotificationDate.text = notification?.date?.dateFormatting()
    }
}

extension NotificationViewController {
    
    func setOflineDataSource() {
        
        let params = [
            "status" : true,
            "message" : "Notification List.",
            "data" : [
                "notifications" : [
                    [
                    "date" : "2017-02-22T08:42:55.496Z",
                    "ticket_id" : 4,
                    "description" : "Ticket Created by Nipun Brahmbhatt,Ticket Created by Nipun Brahmbhatt,Ticket Created by Nipun Brahmbhatt",
                    "user_name" : "Rahul Patel"
                    ]
                ]
            ]
        ] as Any
        
        let json = JSON(params)
        self.processGetResponceNotificationList(json: json["data"], completionHandler: {
            
        })
    }
}
