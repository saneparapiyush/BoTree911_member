//
//  ProjectListViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 02/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import SwiftyJSON
import FTProgressIndicator


class ProjectListViewController: AbstractViewController {
    
    var projectListSource = [Project]()
    
    var selectProjectIndexPath = Int()
    
    var selectedStatusID = Int()
    
    @IBOutlet var tblProjectList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = getLocalizedString("title_project_list")
        
        configNavigationBar()
        
//            MARK: OFLINE
//        getProjectList()
        setOflineDataSource()
//            MARK: END OFLINE
    }
    func configNavigationBar() {
//        showNavigationBar()
        
//        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//        navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }//End configNavigationBar()

//    MARK:- Helper Method
    func getProjectList() {
        
        let serviceManager = ServiceManager()
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("project_list_indicator"), userInteractionEnable: false)
        
        serviceManager.getProjectList { (success, error, json) in
            if success {
                self.projectListSource = json!
                self.tblProjectList.reloadData()
            } else {
                print(error!)
                self.view.makeToast(error!)
            }
            self.dismissIndicator()
        }
    } // End getProjectList()

//  MARK:- Actions
    
    func btnAllTicketOnClick(sender: UIButton){
        //        let buttonTag = sender.tag
        
        selectProjectIndexPath = sender.tag
        selectedStatusID = 0
        self.performSegue(withIdentifier: "showTicketList", sender: self)
    } //End btnAllTicketOnClick()
    
    func btnDetailOnClick(sender: UIButton){
        //        let buttonTag = sender.tag
        
        selectProjectIndexPath = sender.tag
        self.performSegue(withIdentifier: "showProjectDetail", sender: self)
    } //End btnDetailOnClick()
    
    func btnStatus1OnClick(sender: UIButton){
        //        let buttonTag = sender.tag
        
        selectProjectIndexPath = sender.tag
        selectedStatusID = 3
        self.performSegue(withIdentifier: "showTicketList", sender: self)
    } //End btnStatus1OnClick()
    func btnStatus2OnClick(sender: UIButton){
        //        let buttonTag = sender.tag
        
        selectProjectIndexPath = sender.tag
        selectedStatusID = 2
        self.performSegue(withIdentifier: "showTicketList", sender: self)
    } //End btnStatus2OnClick()
    func btnStatus3OnClick(sender: UIButton){
        //        let buttonTag = sender.tag
        
        selectProjectIndexPath = sender.tag
        selectedStatusID = 1
        self.performSegue(withIdentifier: "showTicketList", sender: self)
    } //End btnStatus3OnClick()
    func btnStatus4OnClick(sender: UIButton){
        //        let buttonTag = sender.tag
        
        selectProjectIndexPath = sender.tag
        selectedStatusID = 0
        self.performSegue(withIdentifier: "showTicketList", sender: self)
    } //End btnStatus4OnClick()
    
//    MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTicketList" {
            
            let destVC = segue.destination as! FragmentViewController
            destVC.title = getLocalizedString("title_edit_ticket")
            destVC.selectedIndex = selectedStatusID
            
            let destinationVC = AppRouter.sharedRouter().getViewController("TicketListViewController") as! TicketListViewController
            destinationVC.project = projectListSource[selectProjectIndexPath]
            
//          let ticketListVC = segue.destination as! TicketListViewController
//          ticketListVC.project = projectListSource[selectProjectIndexPath]
            
        } else if segue.identifier == "showProjectDetail" {
            let projectDetailVC = segue.destination as! ProjectDetailViewController
            projectDetailVC.project = projectListSource[selectProjectIndexPath]
        }
    }
}

extension ProjectListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectListSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProjectList.dequeueReusableCell(withIdentifier: "ProjectListCell") as! ProjectListCell
        
        cell.btnAllTicket.tag = indexPath.row
        cell.btnAllTicket.addTarget(self, action: #selector(btnAllTicketOnClick), for: .touchUpInside)
        
        cell.btnDetail.tag = indexPath.row
        cell.btnDetail.addTarget(self, action: #selector(btnDetailOnClick), for: .touchUpInside)
        
        cell.btnStatus1.tag = indexPath.row
        cell.btnStatus1.addTarget(self, action: #selector(btnStatus1OnClick), for: .touchUpInside)
        
        cell.btnStatus2.tag = indexPath.row
        cell.btnStatus2.addTarget(self, action: #selector(btnStatus2OnClick), for: .touchUpInside)
        
        cell.btnStatus3.tag = indexPath.row
        cell.btnStatus3.addTarget(self, action: #selector(btnStatus3OnClick), for: .touchUpInside)
        
        cell.btnStatus4.tag = indexPath.row
        cell.btnStatus4.addTarget(self, action: #selector(btnStatus4OnClick), for: .touchUpInside)
        
        cell.project = projectListSource[indexPath.row]
        cell.setProjectListData()
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ticketVC: TicketListViewController = AppRouter.sharedRouter().getViewController("TicketListViewController") as! TicketListViewController
//        
//        ticketVC.projectId = projectListSource[indexPath.row].id!
        selectProjectIndexPath = indexPath.row
        self.performSegue(withIdentifier: "showTicketList", sender: self)
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == projectListSource.count - 1 {
            return 141.0
        }
        return 133.0
    }
}

class ProjectListCell: UITableViewCell {
    var project: Project?
    
    @IBOutlet var lblProjectTitle: UILabel!
    
    @IBOutlet var lblSPOCPerson: UILabel!
    
    @IBOutlet var btnDetail: UIButton!
    
    @IBOutlet var btnAllTicket: UIButton!
    
    @IBOutlet var btnStatus1: UIButton!
    
    @IBOutlet var btnStatus2: UIButton!
    
    @IBOutlet var btnStatus3: UIButton!
    
    @IBOutlet var btnStatus4: UIButton!
    
    func setProjectListData() {
//        btnProjectInfo.imageView?.contentMode = .center
        lblProjectTitle.text = project?.name
        lblSPOCPerson.text = project?.spoc_person
        
        
        
        /*
        for (index, element) in arrStatusList.enumerated() {
            
            btnStatus.layer.cornerRadius = 4
            btnStatus.setTitle(element, for: .normal)
            btnStatus.frame = CGRect(x: 360, y: 53, width: 30, height: 30)
            btnStatus.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
            
            switch index {
            case 0:
                btnStatus.frame.origin.x = btnStatus.frame.origin.x
                btnStatus.backgroundColor = UIColor.red
            case 1:
                btnStatus.frame.origin.x = btnStatus.frame.origin.x - 38
                btnStatus.backgroundColor = UIColor.green
            case 2:
                btnStatus.frame.origin.x = btnStatus.frame.origin.x - 38 - 38
                btnStatus.backgroundColor = UIColor.blue
            case 3:
                btnStatus.frame.origin.x = btnStatus.frame.origin.x - 38 - 38 - 38
                btnStatus.backgroundColor = UIColor.darkGray
            default:
                print(index)
            }
            self.addSubview(btnStatus)
        }*/
    }
}

extension ProjectListViewController {
    func setOflineDataSource() {
        
        let params = [
            "status": true,
            "data": [
                "projects": [
                    [
                        "id": 1,
                        "name": "Botree 911",
                        "description": "BoTree 911 is a Mobile Application for clients opting for BoTree’s 24 X 7 support",
                        "spoc_person": "Amit Patel",
                        "client": ["Olivia Wilde", "Scarlett Johansson","Emma Stone"],
                        "ticket_status_value":[
                            [
                                "name":"Pending",
                                "value":5
                            ],
                            [
                                "name":"InProgress",
                                "value":4
                            ],
                            [
                                "name":"Resolved",
                                "value":3
                            ],
                            [
                                "name":"Closed",
                                "value":0
                            ]
                        ],
                        "start_date":"Jan 10,2017",
                        "project_manager": [
                            "Nipun BrahmBhatt", "Arpan Christain"
                        ],
                        "team_leader": [
                            "Nipun BrahmBhatt", "Bhavin Nattar"
                        ],
                        "team_member": [
                            "Sailesh Prajapati", "Rahul Sadhu","Prina Patel"
                        ],
                        "total_member": 5
                    ]
                ]
            ]
        ] as Any
        
        let json = JSON(params)
        processGetResponceProjectList(json: json["data"])
        
    }
    
    func processGetResponceProjectList(json: JSON) {
        
        let projects = json["projects"]
        
        for i in 0 ..< projects.count {
            let jsonValue = projects.arrayValue[i]
            let projectDetail = Project(json: jsonValue)
            projectListSource.append(projectDetail)
        }
        self.tblProjectList.reloadData()
    }
}
