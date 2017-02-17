//
//  LogTimeViewController.swift
//  BoTree911_member
//
//  Created by piyushMac on 17/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

class LogTimeViewController: AbstractViewController,NGOPassCodeViewDelegate {

    @IBOutlet var viewLogTime: NGOPassCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLogTime.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func NGOPassCodeViewDidFinishEnteringPassword(password: String) {
        print("password")
    }
    
}
