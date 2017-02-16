//
//  CommentViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 08/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import Alamofire
import FTProgressIndicator
import SwiftyJSON
import Toast

class CommentViewController: AbstractViewController {

    @IBOutlet var tblCommentList: UITableView!
    @IBOutlet var txtAddComment: UITextField!
    
    var ticket: Ticket?
    var commentListSource = [Comment]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }// End viewDidLoad()

    override func viewWillAppear(_ animated: Bool) {
        
        //            MARK: OFLINE
        //        getCommentList()
        setOflineDataSource()
        //            MARK: END OFLINE
        
    }//End viewWillAppear()
    
//    MARK: - Action
    @IBAction func btnAddCommentOnClick(_ sender: Any) {
        addComment()
    }// End btnAddCommentOnClick()
    
//    MARK:- Helper Method
    func addComment() {
        
        let parameters = [
            "ticket": [
                "description": txtAddComment.text!
            ]
        ]

        FTProgressIndicator.showProgressWithmessage(getLocalizedString("add_comment_indicator"), userInteractionEnable: false)
        
        do {
            try Alamofire.request(ComunicateService.Router.AddComment(parameters, (ticket!.id)!).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Add Comment Response: \(json)")
                        
                        if (json.dictionaryObject!["status"] as? Bool)! {
                            self.getCommentList()
                        }
                    }
                    self.dismissIndicator()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.view.makeToast(error.localizedDescription)
                }
            }
        } catch let error{
            print(error.localizedDescription)
            self.dismissIndicator()
            self.view.makeToast(error.localizedDescription)
        }
    }//End addComment()
    
    func getCommentList() {
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("comment_list_indicator"), userInteractionEnable: false)
        do {
            try Alamofire.request(ComunicateService.Router.CommentList((ticket!.id)!).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Comment List Response: \(json)")
                        
                        if (json.dictionaryObject!["status"] as? Bool)! && json["data"]["comments"].count > 0 {
//                            self.processGetResponceCommentList(json: json["data"])
                            self.processGetResponceCommentList(json: json["data"], completionHandler: {
                                self.dismissIndicator()
                            })
                        } else {
                            self.view.makeToast("\((json.dictionaryObject!["message"])!)")
                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            self.dismissIndicator()
//                        }
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
    } // End getCommentList()
    
    func processGetResponceCommentList(json: JSON, completionHandler: () -> Void) {
        commentListSource = [Comment]()
        let comments = json["comments"]
        
        for i in 0 ..< comments.count {
            let jsonValue = comments.arrayValue[i]
            let commentDetail = Comment(json: jsonValue)
            commentListSource.append(commentDetail)
        }
        
        tblCommentList.reloadData()
        completionHandler()
    }// End processGetResponceCommentList
}

extension CommentViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentListSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCommentList.dequeueReusableCell(withIdentifier: "CommentListCell") as! CommentListCell
        
        cell.comment = commentListSource[indexPath.row]
        
        cell.setCellView()
        cell.setProjectListData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == commentListSource.count - 1 {
//            return 100.0
//        }
//        return 68.0 + CommentListCell().configHeightForCell
//    }
}

class CommentListCell: UITableViewCell {
    var comment: Comment?
    
    @IBOutlet var lblCommenterName: UILabel!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var lblCommentDateTime: UILabel!
    
    
    @IBOutlet var constraintTrail: NSLayoutConstraint!// For move view
    @IBOutlet var constraintLead: NSLayoutConstraint!// For move view
    
    func setProjectListData() {
        
        lblCommenterName.text = comment?.user_name
        lblComment.text = comment?.comment
        lblCommentDateTime.text = comment?.date_time
    }
    
    func setCellView() {
        if comment!.user_name! == "piyush" { // change condition based on user detail
            constraintLead.constant = 100
            constraintTrail.constant = 8
        }
    }
}

extension CommentViewController {
    
    func setOflineDataSource() {
        
        let params = [
            "status": true,
            "message": "Ticket comments list.",
            "data": [
                "comments": [
                    [
                        "id": 1,
                        "user_name": "piyush",
                        "comment": "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        "date_time": "Jan 5, 2016"
                    ],
                    [
                        "id": 2,
                        "user_name": "Client",
                        "comment": "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        "date_time": "Jan 5, 2016"
                    ],
                    [
                        "id": 3,
                        "user_name": "Client",
                        "comment": "d",
                        "date_time": "Jan 21, 2016"
                    ]
                ]
            ]
        ] as Any
        
        let json = JSON(params)
        
        self.processGetResponceCommentList(json: json["data"], completionHandler: {
        
        })
    }
}
