//
//  AvailableEmployeeViewController.swift
//  Allok8
//
//  Created by Test User 1 on 11/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

class AvailableEmployeeViewController: AllEmployeeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = Constants.availableScreenTitle

    }

    override func populateEmployeeData() {
        self.employeeData.append(contentsOf: dataManager.getAvailableEmployeeData())
    }
}
