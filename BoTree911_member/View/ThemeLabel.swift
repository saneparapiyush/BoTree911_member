//
//  ThemeLabel.swift
//  Botree911_Client
//
//  Created by piyushMac on 10/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

class ThemeLabelTitle: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = themeTextColor
        self.font = UIFont.boldSystemFont(ofSize: 14.0)
    }
}

class ThemeLabelTitleNormal: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = themeTextColor
        self.font = UIFont.systemFont(ofSize: 14.0)
    }
}

class ThemeLabelDetail: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = themeTextColor
        self.font = UIFont.systemFont(ofSize: 12.0)
    }
}

class ThemeLabelDetailBold: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = themeTextColor
        self.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
    }
}
