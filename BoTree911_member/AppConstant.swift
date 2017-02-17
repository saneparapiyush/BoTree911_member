//
//  AppConstant.swift
//  Botree911
//
//  Created by piyushMac on 01/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

let themeColor = UIColor(red: 33.0/255.0, green: 156.0/255.0, blue: 182.0/255.0, alpha: 1.0)
let themeTextBorderColor = UIColor(red: 228.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0)
let themeTextfieldColor = UIColor(red: 221.0/255.0, green: 227.0/255.0, blue: 236.0/255.0, alpha: 1.0)

let themeTextColor = UIColor.darkGray

let REGEX_EMAIL = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let DEVICE_TOKEN = 1

var selectedProject : Project!

enum AppScreenType: Int {
    case TICKET_LIST_SCREEN_TYPE
}

let ACCEPTABLE_CHARACTERS = "0123456789."
