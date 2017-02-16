//
//  FragmentViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 09/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

class FragmentViewController: AbstractViewController,CarbonTabSwipeNavigationDelegate {

    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var selectedIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        items = ["Pending (2)", "InProgress (1)","Resolved (5)","Closed (3)","Unassigned (2)"]
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        style()
        
//        carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex = 3
        
        title = getLocalizedString("title_ticket_list")
        
        //For Add navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnAddOnClick))
    
//        NotificationCenter.default.addObserver(self, selector: #selector(FragmentViewController.switchTabs), name: NSNotification.Name(rawValue: "switchTabsNotification"), object: nil)
        
    }
//    func switchTabs() {
//        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
//    }
    
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
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(self.view.frame.width / 3.5, forSegmentAt: 4)
        
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.black.withAlphaComponent(0.6))
    }
    
    //    MARK:- Actions
    func btnAddOnClick() {
//        selectedTicket = nil
        self.performSegue(withIdentifier: "showAddTicket", sender: self)
    }// end btnAddOnClick()
}
