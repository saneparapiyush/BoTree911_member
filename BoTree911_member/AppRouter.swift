//
//  AppRouter.swift
//  Botree911
//
//  Created by piyushMac on 01/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

let _sharedRouter: AppRouter = { AppRouter() }()

class AppRouter: NSObject, Controller {
    
    var appWindow : UIWindow?
    var container: UIViewController?
    var subContainerInTabbar: UINavigationController?
    var view: View?
    
    // Singleton class
    class func sharedRouter() -> AppRouter {
        return _sharedRouter
    }
    
    func segueInitiatedForViewController(_ viewController: AbstractViewController) {
        viewController.controller = self
    }
    
    func getViewController(_ screenName: String) -> AbstractViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: screenName) as! AbstractViewController
        return viewController
    }
    
    func getNavigationController() -> UINavigationController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "SlideNavigationController") as! UINavigationController
        return navigationController
    }
    
    // MARK: - Screen Navigation Methods -
    
    func showTicketListScreen() {
        let ticketListVC = getViewController("TicketListViewController") as? TicketListViewController
        
        ticketListVC!.controller = self
        ticketListVC!.screenType = .TICKET_LIST_SCREEN_TYPE
        view = ticketListVC
        
        let navigationController: UINavigationController = getNavigationController()
        navigationController.viewControllers = [ticketListVC!]
        container = navigationController
        
        let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
        appDelegate.window?.rootViewController = navigationController
    }
}

