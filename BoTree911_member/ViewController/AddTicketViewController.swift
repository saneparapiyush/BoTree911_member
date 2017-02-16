//
//  AddTicketViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 06/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import FTProgressIndicator
import SwiftyJSON
import Alamofire
import Toast

class AddTicketViewController: AbstractViewController {
    
    @IBOutlet var txtTitleName: ThemeTextField!
    @IBOutlet var txtViewDescription: UITextView!
    
    @IBOutlet var txtSelectProject: UITextField!
    
    @IBOutlet var lblIssueType: ThemeLabelDetail!
    @IBOutlet var lblSummery: ThemeLabelDetail!
    @IBOutlet var lblDescription: ThemeLabelDetail!
    @IBOutlet var txtSelectStatus: UITextField!
    @IBOutlet var btnCreateTicket: ThemeButton!
    
    @IBOutlet var constraintTop: NSLayoutConstraint!
    
    var picker = UIPickerView()
    var pickerTag: Int = Int()
    
    var ticketStatus = [TicketStatus]()
    var projectListSource = [Project]()
    var ddProjectId: Int?
    
    var project: Project?
    var selectedStatus: TicketStatus?
    
    var ticket: Ticket?
    var isEdit: Bool?
    
    //Edit Ticket
    let fromScreenType: AppScreenType? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(btnSkipOnClick))
        
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        if (ticket != nil) {
            isEdit = true
            lblIssueType.isHidden = false
            txtSelectStatus.isHidden = false
            constraintTop.constant = 101
        } else {
            isEdit = false
            title = getLocalizedString("title_add_ticket")
            
            lblIssueType.isHidden = true
            txtSelectStatus.isHidden = true
            constraintTop.constant = 16
        }
        
        configUI()
        
        //            MARK: OFLINE
        //        getDropDownData()
            setOflineDataSource()
            picker.dataSource = self
            picker.delegate = self
        //            MARK: END OFLINE
        
    }// End viewDidLoad()
    
    func getDropDownData() {
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("status_list_indicator"), userInteractionEnable: false)

        getStatusList()
        getProjectList()
        self.dismissIndicator()
        picker.dataSource = self
        picker.delegate = self
    }
    
//    MARK:- Helper Method
    func getStatusList() {
        
//        FTProgressIndicator.showProgressWithmessage(getLocalizedString("status_list_indicator"), userInteractionEnable: false)
        do {
            try Alamofire.request(ComunicateService.Router.StatusList().asURLRequest()).responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Stutus List Response: \(json)")
                        
                        if (json.dictionaryObject!["status"] as? Bool)! {
                            self.processGetResponceStutusList(json: json["data"])
                        } else {
                            print((json.dictionaryObject!["message"])!)
                            self.configToast(message: "\((json.dictionaryObject!["message"])!)")
                        }
                    }
                    
//                    self.dismissIndicator()
                case .failure(let error):
                    print(error)
                    self.configToast(message: error.localizedDescription)
//                    self.dismissIndicator()
                }
            }
        } catch let error{
            print(error)
            self.configToast(message: error.localizedDescription)
            //            self.dismissIndicator()
        }
    } // End getStatusList()
    
    func processGetResponceStutusList(json: JSON) {
        
        ticketStatus = [TicketStatus]()
        
        let ticketStat = json["ticket_status"]
        for i in 0 ..< ticketStat.count {
            let jsonValue = ticketStat.arrayValue[i]
            let ticketStatusDetail = TicketStatus(json: jsonValue)
            ticketStatus.append(ticketStatusDetail)
        }
        
        //        for (key, value) in projects as! JSON {
        //            arrStatus[key] = (value.intValue)
        //        }
        
        //        txtSelectStatus.text = (isEdit)! ? (ticket?.status) : (arrStatus.allKeys(for: 1)[0] as! String)
        if ticketStatus.count > 1 {
            txtSelectStatus.isEnabled = true
        }
        
        txtSelectStatus.text = (isEdit)! ? (ticket?.status) : ticketStatus[0].ticket_status_name
    } // End procssGetResponceProjectList

//    func processGetResponceTicketList(json: JSON) {
//        ticketListSource = [Ticket]()
//        let projects = json["ticket"]
//        
//        for i in 0 ..< projects.count {
//            let jsonValue = projects.arrayValue[i]
//            let ticketDetail = Ticket(json: jsonValue)
//            ticketListSource.append(ticketDetail)
//        }
//        tblTicketList.reloadData()
//    }
    
    func getProjectList() {
        
        let serviceManager = ServiceManager()

        serviceManager.getProjectList { (success, error, json) in
            if success {
                self.projectListSource = json!
                
                if self.projectListSource.count > 1 {
                    self.txtSelectProject.isEnabled = true
                }
            } else {
                print(error!)
                self.configToast(message: error!)
            }
        }
    } // End getProjectList()
    
    
    func createTicket() {

        let parameters = [
            "ticket": [
            "project_id": project!.id!,
            "name": "\(txtTitleName.text!)",
            "status": selectedStatus!.status_value!,
            "description": "\(txtViewDescription.text!)"
            ]
        ]
        
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("add_project_indicator"), userInteractionEnable: false)
        
        do {
            try Alamofire.request(ComunicateService.Router.CreateTicket(parameters).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Create Project Response: \(json)")
                        
//                        if (json.dictionaryObject!["status"] as? Bool)! {
//                            
//                            print((json.dictionaryObject!["message"])!)
//                        } else {
//                            print((json.dictionaryObject!["message"])!)
//                        }
                        self.configToast(message: "\((json.dictionaryObject!["message"])!)")
                    }
                    
                    self.dismissIndicator()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.configToast(message: error.localizedDescription)
                }
            }
        } catch let error{
            print(error.localizedDescription)
            self.dismissIndicator()
            self.configToast(message: error.localizedDescription)
        }
    }//End CreateTicket()
    
    func editTicket() {
        
        let parameters = [
            "ticket": [
                "project_id": project!.id!,
                "name": "\(txtTitleName.text!)",
                "status": selectedStatus!.status_value!,
                "description": "\(txtViewDescription.text!)"
            ]
        ]
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("update_project_indicator"), userInteractionEnable: false)
        
        do {
            try Alamofire.request(ComunicateService.Router.EditTicket(parameters, (ticket?.id)!).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Edit Project Response: \(json)")
                        
//                        if (json.dictionaryObject!["status"] as? Bool)! {
//                            
//                            print((json.dictionaryObject!["message"])!)
//                        } else {
//                            print((json.dictionaryObject!["message"])!)
//                        }
                        self.configToast(message: "\((json.dictionaryObject!["message"])!)")
                    }
                    
                    self.dismissIndicator()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.configToast(message: error.localizedDescription)
                }
            }
        } catch let error{
            print(error.localizedDescription)
            self.dismissIndicator()
            self.configToast(message: error.localizedDescription)
        }
    }//End editTicket()
    
    func configUI() {
        
        txtViewDescription.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        lblSummery.colorChangeForLastCharacter()
        lblDescription.colorChangeForLastCharacter()
        
        picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 216.0))
        picker.backgroundColor = UIColor.white
        
//        txtSelectProject.addRightSubView()
//        txtSelectStatus.addRightSubView()
        
        txtSelectProject.inputView = picker
        txtSelectStatus.inputView = picker
        
        if isEdit! {
            txtTitleName.text = ticket!.name
            txtViewDescription.text = ticket!.description
            txtSelectStatus.text = ticket!.status
            btnCreateTicket.setTitle("Edit", for: .normal)
        }
    }// End configUI()
    
    func configToast(message: String) {
        self.isEdit! ? self.tabBarController?.view.makeToast(message) : self.view.makeToast(message)
    }//End configToast()


    //MARK:- Actions
    
    @IBAction func btnCreateTicketOnClick(_ sender: Any) {
        if txtTitleName.hasText && txtViewDescription.hasText && txtSelectProject.hasText && txtSelectStatus.hasText {
            
            if (ticket != nil) {
                editTicket()
            } else {
                createTicket()
            }
            performSegue(withIdentifier: "showTicketScreenFromAddScreen", sender: self)
        } else {
            if !txtViewDescription.hasText {
                print("Enter Description")
            } else if !txtSelectProject.hasText {
                print("Select Project")
            } else if !txtSelectStatus.hasText {
                print("Select Status")
            } // Write toast related message
        }
    }// End btnCreateProjectOnClick()
    
//    @IBAction func btnCancelOnClick(_ sender: Any) {
////        self.navigationController?.popViewController(animated: true);
//        self.performSegue(withIdentifier: "show", sender: self)
//    }// End btnCancelOnClick()    
    
    func btnSkipOnClick() {
        performSegue(withIdentifier: "showTicketScreenFromAddScreen", sender: self)
    }
    
}

//MARK: - PICKER
extension AddTicketViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch pickerTag {
        case 101:
            return projectListSource.count
        case 102:
            return ticketStatus.count
        default:
            print(pickerTag)
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerTag {
        case 101:
            project = projectListSource[row]
            txtSelectProject.text = projectListSource[row].name
        case 102:
            selectedStatus = ticketStatus[row]
            txtSelectStatus.text = ticketStatus[row].ticket_status_name
            
        default:
            print(pickerTag)
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textAlignment = NSTextAlignment.center
        
        switch pickerTag {
        case 101:
            label.text = projectListSource[row].name
        case 102:
            label.text = ticketStatus[row].ticket_status_name
            
        default:
            print(pickerTag)
            break
        }
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        picker.selectRow(0, inComponent: 0, animated: true)
        
        switch textField {
        case txtSelectProject:
            if projectListSource.count > 0 {
                pickerTag = 101
                
                //     titlePicker.title = " Select XXXX "
            }
        case txtSelectStatus:
            if ticketStatus.count > 0 {
                pickerTag = 102

                //   titlePicker.title = " Select XXXX "
            }
        default:
            print(textField)
            break
        }
        
        picker.reloadAllComponents()
    }
}
extension AddTicketViewController {
    
    func setOflineDataSource() {
        
        let params = [
            "status": true,
            "message": "Ticket status list.",
            "data": [
                "ticket_status": [
                    [
                        "name": "to_do",
                        "value": 1
                    ],
                    [
                        "name": "in_progress",
                        "value": 2
                    ],
                    [
                        "name": "resolved",
                        "value": 3
                    ],
                    [
                        "name": "close",
                        "value": 4
                    ]
                ]
            ]
            ] as Any
        
        let jsonStatus = JSON(params)
        self.processGetResponceStutusList(json: jsonStatus["data"])
        
        
        let params2 = [
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
        
        let json = JSON(params2)
        processGetResponceProjectList(json: json["data"])
        
    }
    
    func processGetResponceProjectList(json: JSON) {
        
        let projects = json["projects"]
        
        for i in 0 ..< projects.count {
            let jsonValue = projects.arrayValue[i]
            let projectDetail = Project(json: jsonValue)
            projectListSource.append(projectDetail)
        }
        
        if projectListSource.count > 1 {
            txtSelectProject.isEnabled = true
        }
        txtSelectProject.text = projectListSource[0].name
    }
}
