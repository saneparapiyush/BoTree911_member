//
//  TicketDetailViewController.swift
//  BoTree911_member
//
//  Created by piyushMac on 16/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import FTProgressIndicator
import SwiftyJSON
import Alamofire
import Toast

class TicketDetailViewController: AbstractViewController {

    @IBOutlet var txtSelectProject: UITextField!
    @IBOutlet var lblIssueType: ThemeLabelDetail!
    @IBOutlet var txtSelectStatus: UITextField!
    @IBOutlet var lblsummary: ThemeLabelDetail!
    @IBOutlet var txtTitleName: ThemeTextField!
    @IBOutlet var lblDescription: ThemeLabelDetail!
    @IBOutlet var txtViewDescription: UITextView!

    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var btnPassTicket: ThemeButton!
    
    var picker = UIPickerView()
    var ticketStatus = [TicketStatus]()
    var projectListSource = [Project]()
    var ddProjectId: Int?
    
    var selectedStatus: TicketStatus?
    
    var ticket: Ticket?
    
    var selectedStatusId = UInt() // For Unassignee
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        configUI()
        configUIOnStatus()
        
        //            MARK: OFLINE
                getDropDownData()
//        setOflineDataSource()
        picker.dataSource = self
        picker.delegate = self
        //            MARK: END OFLINE
        
    }// End viewDidLoad()
    
    func getDropDownData() {
//        FTProgressIndicator.showProgressWithmessage(getLocalizedString("status_list_indicator"), userInteractionEnable: false)
        
        getStatusList()
//        self.dismissIndicator()
        picker.dataSource = self
        picker.delegate = self
    }//End getDropDownData()
    
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
    
            if ticketStatusDetail.status_value! != 4 { // Hide Close Status 
                ticketStatus.append(ticketStatusDetail)
            }
            if ticketStatusDetail.status_value! == ticket?.status_id {
                txtSelectStatus.text = ticketStatusDetail.ticket_status_name
            }
        }
        
        //        for (key, value) in projects as! JSON {
        //            arrStatus[key] = (value.intValue)
        //        }
        
        //        txtSelectStatus.text = (isEdit)! ? (ticket?.status) : (arrStatus.allKeys(for: 1)[0] as! String)
        
    } // End procssGetResponceProjectList
    
    func editTicket() {
        
        let parameters = [
            "ticket": [
                "project_id": selectedProject!.project_id!,
                "name": "\(txtTitleName.text!)",
                "status": selectedStatus!.status_value!,
                "description": "\(txtViewDescription.text!)",
                "holder_type":"developer"
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
    
    func passTicket() {
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("pass_ticket_indicator"), userInteractionEnable: false)
        do {
            try Alamofire.request(ComunicateService.Router.PassTicket((ticket!.id)!).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Pass Ticket Response: \(json)")
                        
                        self.configToast(message: "\((json.dictionaryObject!["message"])!)")
                        
                        self.dismissIndicator()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.configToast(message: error.localizedDescription)
                }
            }
        } catch let error{
            print(error)
            self.dismissIndicator()
            self.configToast(message: error.localizedDescription)
        }
    } // End passTicket()
    
    func acceptTicket() {
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("accept_ticket_indicator"), userInteractionEnable: false)
        do {
            try Alamofire.request(ComunicateService.Router.AcceptTicket((ticket!.id)!).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Accept Ticket Response: \(json)")
                        
                        self.configToast(message: "\((json.dictionaryObject!["message"])!)")
                        
                        self.dismissIndicator()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.configToast(message: error.localizedDescription)
                }
            }
        } catch let error{
            print(error)
            self.dismissIndicator()
            self.configToast(message: error.localizedDescription)
        }
    } // End acceptTicket()
    
    func configUI() {
        
        txtSelectProject.text = selectedProject?.name
        
        txtViewDescription.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        lblsummary.colorChangeForLastCharacter()
        lblDescription.colorChangeForLastCharacter()
        
        picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 216.0))
        picker.backgroundColor = UIColor.white
        
        txtSelectStatus.inputView = picker
        
        txtTitleName.text = ticket!.name
        txtViewDescription.text = ticket!.description
//        txtSelectStatus.text = ticket!.status
    }// End configUI()
    
    func configUIOnStatus() {
        
        switch selectedStatusId {
            case UNASSIGNEE_ID:
                btnEdit.isHidden = true
                btnPassTicket.setTitle("Accept Ticket", for: .normal)
            
            case UNRESOLVED_ID:
                break
            
            case MISSED_ID:
                btnEdit.isHidden = true
                btnPassTicket.isHidden = true
            
            case OLD_ID:
                btnEdit.isHidden = true
                btnPassTicket.isHidden = true
                
            default:
                break
        }
    }
    
//MARK: - ACTION
    
    @IBAction func btnEditOnClick(_ sender: Any) {
        
        if btnEdit.currentTitle == "Save" {//Button Save Click
            btnEdit.setTitle("", for: .normal)
            btnEdit.setImage(UIImage(named: "edit"), for: .normal)
            
            txtSelectStatus.isEnabled = false
            
            editTicket()
            
        } else {//Button Edit Click
            btnEdit.setTitle("Save", for: .normal)
            btnEdit.setImage(nil, for: .normal)
            
            txtSelectStatus.isEnabled = true
        }
        
    }// End btnEditOnClick()
    
    @IBAction func btnPassTicketOnClick(_ sender: Any) {
        
        if btnPassTicket.title(for: .normal) == "Accept Ticket" {
            acceptTicket()
        } else {
            passTicket()
        }
        
    }// End btnPassTicketOnClick(0
    
}

//MARK: - PICKER
extension TicketDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return ticketStatus.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStatus = ticketStatus[row]
        txtSelectStatus.text = ticketStatus[row].ticket_status_name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textAlignment = NSTextAlignment.center
        label.text = ticketStatus[row].ticket_status_name
        
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
//        picker.selectRow(0, inComponent: 0, animated: true)
        
        picker.reloadAllComponents()
    }
}

extension TicketDetailViewController {
    
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
    }
}
