//
//  Utility.swift
//  Botree911
//
//  Created by piyushMac on 01/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit


func getLocalizedString(_ localizedKey: String) -> String {
    return NSLocalizedString(localizedKey, comment: "")
}

func getUserName(fName: String, lName: String) -> String{
    return fName + " " + lName
}

extension UITextField {
    func addRightSubView() {
        let view = UIView(frame: CGRect(x: self.frame.origin.x - 40, y: 0, width: 30, height: 30))
        let imgView = UIImageView(frame: CGRect(x: 0.0, y: 0, width: 30, height: 30))
        imgView.image = UIImage(named: "drop_down")
        imgView.contentMode = .center
        view.addSubview(imgView)
        self.rightView = view
        rightViewMode = .always
    }
}

extension UILabel {
    func colorChangeForLastCharacter() {
        
        let myMutableString = NSMutableAttributedString(string: self.text!)
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location: self.text!.characters.count - 1,length:1))
        
        self.attributedText = myMutableString
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func dateFormatting() -> String {// For Converting date to our own format
        
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormat = formatterDate.date(from: self)
        
        let formatterString = DateFormatter()
        formatterString.dateFormat = "MM-dd-yyyy"
        return formatterString.string(from: dateFormat!)
    }
}

//  MARK: UIButton Enable Disale Configution
extension UIButton {
    func isEnableConfig() {
        self.alpha = 1.0
        self.isEnabled = true
    }
    func isDisableConfig() {
        self.alpha = 0.5
        self.isEnabled = false
    }
}


// MARK: SlideMenu Delegate
extension FragmentViewController: SlideNavigationControllerDelegate {
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool
    {
        return true
    }
}

extension TicketDetailViewController {
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool
    {
        return true
    }
}
