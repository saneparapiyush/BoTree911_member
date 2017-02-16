//
//  ProjectDetailViewController.swift
//  Botree911_Client
//
//  Created by piyushMac on 10/02/17.
//  Copyright © 2017 piyushMac. All rights reserved.
//

import UIKit

class ProjectDetailViewController: AbstractViewController {
    
    var project : Project?
    @IBOutlet var scrlView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Project id : \(project?.id)")
        title = getLocalizedString("title_project_info")
        
        self.view.addSubview(scrlView)
        
    }// End viewDidLoad()
    
    override func viewDidLayoutSubviews() {
        self.scrlView.contentSize = CGSize(width:414, height: 777)
//        self.scrlView.contentSize = CGSize(width: self.scrlView.frame.width, height: self.scrlView.frame.height)
    }
}
