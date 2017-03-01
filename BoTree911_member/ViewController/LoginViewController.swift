//
//  LoginViewController.swift
//  Botree911
//
//  Created by piyushMac on 01/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FTProgressIndicator
import Toast

class LoginViewController: AbstractViewController {
    
    @IBOutlet var txtUserEmail: ThemeTextField!
    @IBOutlet var txtPassword: ThemeTextField!
    @IBOutlet var btnLogin: UIButton!
    
    let btnShowHide = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        if let user = UserDefaults.standard.value(forKey: "user") {
//            print(user)
//            print((user as AnyObject)["email"] as! String)
//        }
        
        title = "Sign In"
        //hideNavigationBar()
        self.navigationItem.setHidesBackButton(true, animated: true)
        configValidation()
        configPasswordHideShow()
        textFeildReturnUIConfig()
    }// End viewDidLoad()
    
    override func viewWillDisappear(_ animated: Bool) {
        showNavigationBar()
    }
    //    MARK: Action
    @IBAction func btnLoginOnclick(_ sender: Any) {
        userAuthorized()
    }// End btnLoginOnclick()
    @IBAction func btnForgotPasswordOnClick(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot Password", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.delegate = self
            textField.text = ""
            textField.placeholder = "Please enter user email"
            textField.keyboardType = .numbersAndPunctuation
        }
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField?.text)")
            
            self.forgotPassword(for: (textField?.text)!)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }// End btnForgotPasswordOnClick()
    
    //    MARK: - Helper Method
    
    func forgotPassword(for email : String) {
        
        let parameters = [
            "email": email,
            "device_token": UUID().uuidString
        ]
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("forgot_password_indicator"), userInteractionEnable: false)
        
        do {
            try Alamofire.request(ComunicateService.Router.ForgotPassword(parameters).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Forgot Password Response: \(json)")
                        
                        self.configToast(message: "\((json.dictionaryObject!["message"])!)")
                        self.dismissIndicator()
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
    } //End forgotPassword()

    //    MARK: Email Validation
    
    func configValidation()
    {
//        txtUserEmail.addRegx(REGEX_EMAIL, withMsg: getLocalizedString("invalid_email"))
    }// End isValidEmail
}

//    MARK: KeyBoard Return Key Configuration
extension LoginViewController : UITextFieldDelegate {
    
    func textFeildReturnUIConfig() {
        txtUserEmail.returnKeyType = .next
        txtPassword.returnKeyType = .go
        
        txtUserEmail.enablesReturnKeyAutomatically = true
        txtPassword.enablesReturnKeyAutomatically = true
    }//End textFeildReturnUIConfig()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case txtUserEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            userAuthorized()
            break
        default:
            break
        }
        return false
    }// End textFieldShouldReturn()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }// End touchesBegan()
    
    
    func configPasswordHideShow() {
        btnShowHide.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btnShowHide.setImage(UIImage(named: "show"), for: .normal)
        btnShowHide.setTitleColor(UIColor.darkGray, for: .normal)
        btnShowHide.addTarget(self, action: #selector(btnShowHideOnClick), for: .touchUpInside)
        
        txtPassword.rightViewMode = .always
        txtPassword.rightView = btnShowHide
    }
    func btnShowHideOnClick(sender: UIButton) {
        txtPassword.isSecureTextEntry = !txtPassword.isSecureTextEntry
        txtPassword.isSecureTextEntry ? btnShowHide.setImage(UIImage(named: "show"), for: .normal) : btnShowHide.setImage(UIImage(named: "hide"), for: .normal)
    }
}

extension LoginViewController:AuthorizedProtocol {
    
//    MARK:- Helper Method
    func login(){
        
        let parameters: Parameters = [
            "user": [
                "email": "\(txtUserEmail.text!)",
                "password": "\(txtPassword.text!)",
                "device_type":DEVICE_TOKEN
            ],
            "device_token": UUID().uuidString//uuid for iPhone
        ]
        
        FTProgressIndicator.showProgressWithmessage(getLocalizedString("login_indicator"), userInteractionEnable: false)
        
        do {
          try Alamofire.request(ComunicateService.Router.SignIn(parameters).asURLRequest()).debugLog().responseJSON(options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers])
            {
                (response) -> Void in
                
                print(NSString(data: (response.request?.httpBody!)!, encoding:String.Encoding.utf8.rawValue)!)
                
                switch response.result
                {
                case .success:
                    if let value = response.result.value
                    {
                        let json = JSON(value)
                        print("Login Response: \(json)")
                        
//                        isLoginAuthorized = (json.dictionaryObject!["status"] as? Bool)!
                    
                        if (json.dictionaryObject!["status"] as? Bool)! {

                            if self.storeLoginData(json: json["data"]) {
                                self.dismissIndicator()
                                 self.performSegue(withIdentifier: "showTicketList", sender: self)
                            }
                            
                            //                            UserDefaults.standard.set((json.dictionaryObject!["data"] as! [String: Any])["user"]!, forKey: "user")
                            
                        } else {
//                            print((json.dictionaryObject!["message"])!)
                            self.dismissIndicator()
                            self.view.makeToast("\((json.dictionaryObject!["message"])!)")
                        }
                    }
                    
                    self.dismissIndicator()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.dismissIndicator()
                    self.view.makeToast(error.localizedDescription)
                }
            }
        } catch let error{
            print(error.localizedDescription)
            self.dismissIndicator()
            self.view.makeToast(error.localizedDescription)
        }
//       return isLoginAuthorized
    }// End login()
    
    func loginDataSource(json: JSON) {//unused
        
            let data = json["user"]
      
            let dic = NSMutableDictionary()
            dic.setValue(data["first_name"].rawString()!, forKey: "first_name")
            dic.setValue(data["last_name"].rawString()!, forKey: "last_name")
            dic.setValue(data["email"].rawString()!, forKey: "email")
            dic.setValue(data["access_token"].rawString()!, forKey: "access_token")
        
            UserDefaults.standard.set(dic, forKey: "user")
    }// loginDataSource()
    
    func storeLoginData(json: JSON) -> Bool {
        let data = json["user"]
        
        let dic = NSMutableDictionary()
        dic.setValue(data["first_name"].rawString()!, forKey: "first_name")
        dic.setValue(data["user_id"].rawValue, forKey: "user_id")
        dic.setValue(data["last_name"].rawString()!, forKey: "last_name")
        dic.setValue(data["email"].rawString()!, forKey: "email")
        dic.setValue(data["access_token"].rawString()!, forKey: "access_token")
        
        UserDefaults.standard.set(dic, forKey: "user")
        UserDefaults.standard.set(txtPassword.text!, forKey: "isLogin")
        UserDefaults.standard.set(true, forKey: "isLogin")
        
        if UserDefaults.standard.value(forKey: "isLogin") != nil {
            return true
        }
        
//        if keychain.set(txtPassword.text!, forKey: "password") {
//            return true
//        }
        
        return false
    }//storeLoginData()
    
    //    MARK: Store User Information
    func userAuthorized() {
//        if txtPassword.validate() && txtUserEmail.validate() {
        
//            MARK: OFLINE
            login()
//            self.performSegue(withIdentifier: "showTicketList", sender: self)
//            MARK: END OFLINE
        
    } //End userAuthorized()
}

protocol AuthorizedProtocol {
    func userAuthorized()
}
