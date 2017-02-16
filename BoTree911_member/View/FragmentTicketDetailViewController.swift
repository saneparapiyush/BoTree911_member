//
//  FragmentTicketDetailViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 15/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

class FragmentTicketDetailViewController: AbstractViewController,CarbonTabSwipeNavigationDelegate {
    
    var items = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var project: Project?
    var ticket: Ticket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = ["Details", "History","Comment"]
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        style()
        
        //        carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentIndex = 3
//        carbonTabSwipeNavigation.currentTabIndex = UInt(selectedIndex)
        
//        title = getLocalizedString("title_ticket_list")
    }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
           let vc = AppRouter.sharedRouter().getViewController("AddTicketViewController") as! AddTicketViewController
            vc.project = project
            vc.ticket = ticket
            
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
}
