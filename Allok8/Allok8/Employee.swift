//
//  Employee.swift
//  Allok8
//
//  Created by Test User 1 on 17/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

class Employee: NSObject {
    var guId: String!
    var employeeId: String!
    var allocation: NSNumber?
    var endDate: Date?
    var enGStatus: String?
    var name: String?
    var projectName: String?
    var resourceLocation: String?
    var resourceTypeDemand: String?
    var srType: String?
    var startDate: Date?
    var workOrder: String?
    var actualWOStartDate: Date?
    var actualWOEndDate: Date?
    var WOOwner: String?
    var scheduledWOStartDate: Date?
    var scheduledWOEndDate: Date?
    
    var domain = [String: String]()
    var skillsSet = [String: String]()
    var toolsSet = [String: String]()
    var certification = [String: String]()
   
}
