//
//  FragmentViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 09/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import Toast
import SwiftyJSON

class FragmentViewController: AbstractViewController,CarbonTabSwipeNavigationDelegate {

    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var selectedIndex = Int()

    var picker = UIPickerView()
    var projectListSource = [Project]()
    let txtNavigationTitle = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = ["Old", "Missed","Unresolved","Unassigned"]
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        style()
        
//        carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex = 3
        
//        title = getLocalizedString("title_ticket_list")
        configNavigationTitle()
        configPicker()
        
        //            MARK: OFLINE
        //        getProjectList()
        setOflineDataSource()
        picker.dataSource = self
        picker.delegate = self
        //            MARK: END OFLINE
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            return AppRouter.sharedRouter().getViewController("TicketListViewController") as! TicketListViewController
        case 1:
            return AppRouter.sharedRouter().getViewController("TicketListViewController") as! TicketListViewController
        default:
            return AppRouter.sharedRouter().getViewController("TicketListViewController") as! TicketListViewController
        }
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
    
    func style()
    {
        //        self.navigationController!.navigationBar.translucent = false
        //        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        //        self.navigationController!.navigationBar.barTintColor = color
        //        self.navigationController!.navigationBar.barStyle = .BlackTranslucent
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(themeColor)
        carbonTabSwipeNavigation.setSelectedColor(themeColor, font: UIFont.boldSystemFont(ofSize: 14))
        //        carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.yellowColor()
        
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3.5, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3.5, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3.5, forSegmentAt: 2)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3.5, forSegmentAt: 3)
                
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
    }
    
    func configNavigationTitle() {
        txtNavigationTitle.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        txtNavigationTitle.placeholder = "Select Project"
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
    
//    MARK:- Helper Method
    
    func getProjectList() {
        
        let serviceManager = ServiceManager()
        
        serviceManager.getProjectList { (success, error, json) in
            if success {
                self.projectListSource = json!
                selectedProject = self.projectListSource[0]
                
//                if self.projectListSource.count > 1 {
//                    self.txtSelectProject.isEnabled = true
//                }
            } else {
                print(error!)
                self.view.makeToast(error!)
            }
        }
    } // End getProjectList()
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
}

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
}
