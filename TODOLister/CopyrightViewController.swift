//
//  CopyrightViewController.swift
//  TODOLister
//
//  Created by Volodymyr Lavryk on 28.12.16.
//  Copyright © 2016 Volodymyr Lavryk. All rights reserved.
//

import UIKit

class CopyrightViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
