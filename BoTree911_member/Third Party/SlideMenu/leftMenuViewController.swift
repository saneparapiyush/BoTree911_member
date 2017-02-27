//
//  leftMenuViewController.swift
//  demoSlideMenu
//
//  Created by piyushMac on 17/06/16.
//  Copyright © 2016 piyushMac. All rights reserved.
//

import UIKit

class leftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    let dsTitle = ["Tickets","Unassigned Tickets","Notifications","Logout"]
    let dsMenuImage = [UIImage(named: "ticket"),UIImage(named: "unassign"),UIImage(named: "notification"),UIImage(named: "logout")]
    
    override func viewDidLoad() {
        let fname = (UserDefaults.standard.value(forKey: "user")! as AnyObject)["first_name"] as? String
        let lname = (UserDefaults.standard.value(forKey: "user")! as AnyObject)["last_name"] as? String
        
        lblUserName.text = getUserName(fName: fname!,lName: lname!)
        lblEmail.text = (UserDefaults.standard.value(forKey: "user")! as AnyObject)["email"] as? String
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dsTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblView.dequeueReusableCell(withIdentifier: "leftMenuCell") as! leftMenuCell
            
        cell.imgMenuIcon.image = dsMenuImage[indexPath.row]
        cell.lblMenuTitle.text = dsTitle[indexPath.row]
            
        return cell
//        cell?.backgroundColor = UIColor.redColor()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 61
        } else {
            return 51
        }
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.width, height: 100))
//        view.backgroundColor = themeBlueColor
//        return view
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        var vc : UIViewController?

        switch indexPath.row {
        case 0:// Tickets
            let vc = AppRouter.sharedRouter().getViewController("FragmentViewController") as! FragmentViewController
           
            vc.selectedIndex = 0
            SlideNavigationController.sharedInstance().pushViewController(vc, animated: false)
           
            break
            
        case 1:// Unassigned Tickets
            let vc = AppRouter.sharedRouter().getViewController("FragmentViewController") as! FragmentViewController
            vc.selectedIndex = 3

            SlideNavigationController.sharedInstance().pushViewController(vc, animated: false)
                       
//                        navigateView(to: vc)
            break
        
        case 2:// Notifications
            let vc = AppRouter.sharedRouter().getViewController("NotificationViewController") as! NotificationViewController
            
            SlideNavigationController.sharedInstance().pushViewController(vc, animated: false)
            //            navigateView(to: vc)0
            break
            
        case 3:// Logout
            
            UserDefaults.standard.removeObject(forKey: "user")
            UserDefaults.standard.removeObject(forKey: "isLogin")
            
            let vc = AppRouter.sharedRouter().getViewController("LoginViewController") as! LoginViewController
            
            navigateView(to: vc)
            
            break
            
        default:
            break
        }
//        If Animation True Then Display first all page then pop
    }
    
    func navigateView(to viewController: UIViewController) {
        SlideNavigationController.sharedInstance().popToRootAndSwitch(to: viewController, withSlideOutAnimation: false, andCompletion: nil)
    }
    
}

class leftMenuCell: UITableViewCell {

    @IBOutlet weak var imgMenuIcon: UIImageView!
    
    @IBOutlet weak var lblMenuTitle: UILabel!
}
//
//class SyncCell: UITableViewCell {
//    
//    @IBOutlet weak var lblPreviousSync: UILabel!
//    
//    @IBAction func btnSyncPressed(_ sender: AnyObject) {
//        
//    }
//}
//class MenuHeaderCell: UITableViewCell {
//    @IBOutlet weak var btnUserProfilePic: UIButton!
//    
//    @IBOutlet weak var lblUserName: UILabel!
//    
//    @IBOutlet weak var lblUserEmail: UILabel!
//    
//    @IBAction func btnSettingOnClick(_ sender: Any) {
//        leftMenuViewController().navigateView(to: AppRouter.sharedRouter().getViewController("SettingViewController") as! SettingViewController)
//    }
//    
//}
