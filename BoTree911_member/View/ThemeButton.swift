//
//  ThemeButton.swift
//  Botree911
//
//  Created by piyushMac on 01/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 3.0
        self.backgroundColor = themeColor
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
