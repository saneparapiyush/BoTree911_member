//
//  FragmentViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 09/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import FTProgressIndicator
import Alamofire
import SwiftyJSON

class FragmentViewController: AbstractViewController,CarbonTabSwipeNavigationDelegate {

    var items = [String]()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var selectedIndex = Int()

    var picker = UIPickerView()
    var projectListSource = [Project]()
    let txtNavigationTitle = UITextField()
    
    var allTickets: JSON! = nil
    var ticketListSource = [Ticket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavigationTitle()
    
        configPicker()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //            MARK: OFLINE
        carbonTabSwipeNavigation.removeFromParentViewController()
            getProjectList { (success) in
                if success {
                    self.getTicketList()
                }
            }
        //        setOflineDataSource()
            picker.dataSource = self
            picker.delegate = self
        //            MARK: END OFLINE

    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        let vc = AppRouter.sharedRouter().getViewController("TicketListViewController") as! TicketListViewController
        
        ticketListSource = [Ticket]()
        
        var statusKey = ""
        
        switch index {
        case 0:
            
            statusKey = "unassigned_tickets"
            
            break
        case 1:
            
            statusKey = "on_going_tickets"
            
            break
            
        case 2:
            
            statusKey = "missed_tickets"
            
            break
            
        case 3:
            
            statusKey = "old_tickets"
            
            break
            
        default:
            break
        }
        
        for i in 0 ..< allTickets[statusKey].count {
            let jsonValue = allTickets[statusKey].arrayValue[i]
            let ticketDetail = Ticket(json: jsonValue)
            ticketListSource.append(ticketDetail)
        }
        
        vc.ticketListSource = ticketListSource
        vc.selectedStatusId = index
        
        return vc
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt)
    {
        NSLog("Did move at index: %ld", index)
        
        /*switch index {
        case 0:
            carbonTabSwipeNavigation.setIndicatorColor(UIColor(red: 255/255, green: 16/255, blue: 8/255, alpha: 1))
            carbonTabSwipeNavigation.setSelectedColor(UIColor(red: 255/255, green: 16/255, blue: 8/255, alpha: 1), font: UIFont.boldSystemFont(ofSize: 14))

        case 1:
            carbonTabSwipeNavigation.setIndicatorColor(UIColor(red: 255/255, green: 119/255, blue: 50/255, alpha: 1))
            carbonTabSwipeNavigation.setSelectedColor(UIColor(red: 255/255, green: 119/255, blue: 50/255, alpha: 1), font: UIFont.boldSystemFont(ofSize: 14))

        case 2:
            carbonTabSwipeNavigation.setIndicatorColor(UIColor(red: 0/255, green: 72/255, blue: 226/255, alpha: 1))
            carbonTabSwipeNavigation.setSelectedColor(UIColor(red: 0/255, green: 72/255, blue: 226/255, alpha: 1), font: UIFont.boldSystemFont(ofSize: 14))

        case 3:
            carbonTabSwipeNavigation.setIndicatorColor(themeColor)
            carbonTabSwipeNavigation.setSelectedColor(themeColor, font: UIFont.boldSystemFont(ofSize: 14))

        default:
            print(index)
        }*/
    }
    
    func setUpFragmentMenu() {
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
//        for (index, _) in items.enumerated() {
//            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 2.5 , forSegmentAt: index)
//        }
        
    }
    
    func style()
    {
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(themeColor)
        carbonTabSwipeNavigation.setSelectedColor(themeColor, font: UIFont.boldSystemFont(ofSize: 14))
        
        carbonTabSwipeNavigation.setTabExtraWidth(20)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
    }
    
    func configNavigationTitle() {
        txtNavigationTitle.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        txtNavigationTitle.textAlignment = .center
        txtNavigationTitle.delegate = self
        txtNavigationTitle.textColor = UIColor.white
        txtNavigationTitle.tintColor = UIColor.clear
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        let imgdropDown = UIImageView(frame: CGRect(x: 110, y: 0, width: 40, height: 40))
        imgdropDown.image = UIImage(named: "drop_down")
        imgdropDown.contentMode = .center
        
        view.addSubview(imgdropDown)
        view.addSubview(txtNavigationTitle)
        
        self.navigationItem.titleView = view
    }
    
    func configPicker() {
        picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 216.0))
        picker.backgroundColor = UIColor.white
        txtNavigationTitle.inputView = picker
    }
}

//MARK: - PICKER
extension FragmentViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return projectListSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//            project = projectListSource[row]
        
        selectedProject = projectListSource[row]
        txtNavigationTitle.text = projectListSource[row].name
        txtNavigationTitle.resignFirstResponder()
        
        getTicketList()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 18)
        label.textAlignment = NSTextAlignment.center
        
        label.text = projectListSource[row].name
        return label
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        picker.selectRow(0, inComponent: 0, animated: true)
        picker.reloadAllComponents()
    }
    
    //    MARK:- Helper Method
    
    func getProjectList(completionHandler: @escaping (Bool) -> Void) {
        
        let serviceManager = ServiceManager()
        
        serviceManager.getProjectList { (success, error, json) in
            if success {
                self.projectListSource = json!
                
//                selectedProject = self.projectListSource[0]
//                self.txtNavigationTitle.text = self.projectListSource[0].name
                
                if selectedProject != nil {
                    self.txtNavigationTitle.text = selectedProject?.name
                } else {
                    selectedProject = self.projectListSource[0]
                    self.txtNavigationTitle.text = self.projectListSource[0].name
                }
                
                //                if self.projectListSource.count > 1 {
                //                    self.txtSelectProject.isEnabled = true
                //                }
                completionHandler(true)
            } else {
                print(error!)
                self.view.makeToast(error!)
                completionHandler(false)
            }
        }
    } // End getProjectList()
    
    func getTicketList() {
        
        let params: Parameters = [
            "project_id": selectedProject!.project_id!
        ]
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("ticket_list_indicator"), userInteractionEnable: false)
        do {
            try Alamofire.request(ComunicateService.Router.TicketList(params).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Ticket List Response: \(json)")
                        self.dismissIndicator()
                        
                        if (json.dictionaryObject!["status"] as? Bool)! && json["data"]["tickets"].count > 0 {
                            self.processGetResponceTicketList(json: json["data"])
                        } else {
                            //                            print((json.dictionaryObject!["message"])!)
                            self.view.makeToast("\((json.dictionaryObject!["message"])!)")
                        }
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
    } // End getTicketList()
    
    func processGetResponceTicketList(json: JSON) {
        
        allTickets = json["tickets"]
        items.removeAll()
        //        items = ["To do","In Progress","Resolved","Close","Unassigned"]
        
        items.append("Unassigned (\(allTickets["unassigned_tickets"].count))")
        items.append("Unresolved (\(allTickets["on_going_tickets"].count))")
        items.append("Missed (\(allTickets["missed_tickets"].count))")
        items.append("Old (\(allTickets["old_tickets"].count))")
        
        //        for (key, value) in allTickets {
        //            items.append(key + " (\(value.count))")
        //        }
        
        setUpFragmentMenu()
        style()
        
        /*  for i in 0 ..< projects.count {
         let jsonValue = projects.arrayValue[i]
         let ticketDetail = Ticket(json: jsonValue)
         ticketListSource.append(ticketDetail)
         }*/
        //        tblTicketList.reloadData()
    }// End procssGetResponceProjectList
}
/*
extension FragmentViewController {
    
    func setOflineDataSource() {
        
        let params = [
            "status": true,
            "data": [
                "projects": [
                    [
                        "id": 1,
                        "name": "BoTree911",
                        "start_date":"Jan 10,2017",
                        "total_member": 5
                    ],
                    [
                        "id": 2,
                        "name": "InspectDate",
                        "start_date":"Jan 10,2017",
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
//        
//        if projectListSource.count > 1 {
//            txtSelectProject.isEnabled = true
//        }
        
        selectedProject = projectListSource[0]
        txtNavigationTitle.text = selectedProject.name
    }
}*/
