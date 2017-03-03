//
//  FragmentTicketDetailViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 15/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import FTProgressIndicator
import Alamofire
import SwiftyJSON

class FragmentTicketDetailViewController: AbstractViewController,CarbonTabSwipeNavigationDelegate,UITextFieldDelegate {
    
    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var ticket: Ticket?
    
    var selectedIndex = Int()
    
    var selectedStatusId = UInt()// For Unassignee
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ["Details", "History","Comment"]
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        style()
        
        configLogTimeOnStatus()
        
//        carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex = 3
//        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
        
//        title = getLocalizedString("title_ticket_list")
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
           let vc = AppRouter.sharedRouter().getViewController("TicketDetailViewController") as! TicketDetailViewController
            vc.ticket = ticket
            vc.selectedStatusId = selectedStatusId
            
            return vc
            
        case 1:
           let vc = AppRouter.sharedRouter().getViewController("HistoryViewController") as! HistoryViewController
            vc.ticket = ticket
            return vc
            
        case 2:
           let vc = AppRouter.sharedRouter().getViewController("CommentViewController") as! CommentViewController
            vc.ticket = ticket
            
            return vc
            
        default:
            print(index)
            return UIViewController()
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt)
    {
        NSLog("Did move at index: %ld", index)
    }
    
    func style()
    {
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(themeColor)
        carbonTabSwipeNavigation.setSelectedColor(themeColor, font: UIFont.boldSystemFont(ofSize: 14))
        
        carbonTabSwipeNavigation.setTabExtraWidth(30)
        
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3, forSegmentAt: 2)
        
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
    }
    
    func configLogTimeOnStatus() {
        //For Add navigation bar button
        
        let btnLogtime = UIBarButtonItem(title: "Log Time", style: .plain, target: self, action: #selector(btnLogTimeOnClick))
        
        switch selectedStatusId {
            
        case UNASSIGNEE_ID:
            break
            
        case UNRESOLVED_ID:
            navigationItem.rightBarButtonItem = btnLogtime
            
        case MISSED_ID:
            break
            
        case OLD_ID:
            navigationItem.rightBarButtonItem = btnLogtime
            
        default:
            navigationItem.rightBarButtonItem = btnLogtime
        }
        
    }
    
    //    MARK:- Actions
    func btnLogTimeOnClick() {
        
        let alert = UIAlertController(title: "Log Time", message: "Enter Log Time must in Hours.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.delegate = self
            textField.text = ""
            textField.placeholder = "e.g. 3.5 or 4"
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            
            if let n = NumberFormatter().number(from: (textField?.text)!) {
                self.AddLogTimeOnClick(logTime: CGFloat(n))
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }// end btnAddOnClick()
    
    func AddLogTimeOnClick(logTime : CGFloat) {
        
        let parameters = [
            "ticket": [
                "description": logTime
            ]
        ]
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("logtime_indicator"), userInteractionEnable: false)
        
        do {
            try Alamofire.request(ComunicateService.Router.LogTime(parameters, (ticket!.id)!).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Log Time Response: \(json)")

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
    }
}
extension FragmentTicketDetailViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        
        let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        return (string == filtered)
    }
}
