//
//  DataManager.swift
//  Allok8
//
//  Created by Test User 1 on 17/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    let kkeyNullValueString = "No"
    
    var employeeData = [Employee]()
    static let sharedDataManager = DataManager()
    
    class var sharedInstance: DataManager {
        
        return sharedDataManager
    }
    
    override init() {
        super.init()
    }
    
    public func initEmployeeArrayFromSnapshotDictionary(employeeSnapshot: NSDictionary) {
        
        self.employeeData.removeAll()
        
        //Iterate through employeeSnapshot
        print(employeeSnapshot)
        
        for (key, value) in employeeSnapshot {
            if let valueDictionary = value as? NSDictionary {
                
                print(valueDictionary)
                //Convert to Employee object
                let employee = Employee()
                
                if let employeeGuidId = key as? String {
                    employee.guId = employeeGuidId
                }
                if let employeeId = valueDictionary[Constants.kkeyEmployeeID] as? String {
                    employee.employeeId = employeeId
                }
        
                if let name = valueDictionary[Constants.kkeyEmployeeName] as? String {
                    employee.name = name
                }
                
                if let projectName = valueDictionary[Constants.kkeyProjectName] as? String {
                    employee.projectName = projectName
                }
                
                if let allocation = valueDictionary[Constants.kkeyAllocation] as? NSNumber {
                    employee.allocation = allocation
                }
                
                if let resourceLocation = valueDictionary[Constants.kkeyResourceLocation] as? String {
                    employee.resourceLocation = resourceLocation
                }
                
                if let resourceTypeDemand = valueDictionary[Constants.kkeyResourceTypeDemand] as? String {
                    employee.resourceTypeDemand = resourceTypeDemand
                }
                
                if let srType = valueDictionary[Constants.kkeySRType] as? String {
                    employee.srType = srType
                }
                
                if let workOrder = valueDictionary[Constants.kkeyWorkOrder] as? Int {
                    
                    employee.workOrder = String(workOrder)
                  // print("number workOrder is  %f", valueDictionary[kkeyWorkOrder] as? NSNumber)
                   // print(workOrder)
                    print("number workOrder string is", workOrder,employee.workOrder)

                }
                
                if let WOOwner = valueDictionary[Constants.kkeyWOOwner] as? String {
                    employee.WOOwner = WOOwner
                }
                
                if let endDate = valueDictionary[Constants.kkeyEndDate] as? String,
                    let date  = Utility.dateFromString(dateString: endDate) {
                    employee.endDate = date
                }
                
                if let startDate = valueDictionary[Constants.kkeyStartDate] as? String,
                    let date  = Utility.dateFromString(dateString: startDate) {
                    employee.startDate = date
                }
                
                if let actualWOStartDate = valueDictionary[Constants.kkeyWOActualStartDate] as? String,
                    let date  = Utility.dateFromString(dateString: actualWOStartDate) {
                    employee.actualWOStartDate = date
                }
                
                if let actualWOEndDate = valueDictionary[Constants.kkeyWOActualEndDate] as? String,
                let date  = Utility.dateFromString(dateString: actualWOEndDate) {
                    employee.actualWOEndDate = Utility.dateFromString(dateString: actualWOEndDate)
                }
                
                if let scheduledWOStartDate = valueDictionary[Constants.kkeyWOScheduleStartDate] as? String,
                    let date  = Utility.dateFromString(dateString: scheduledWOStartDate) {
                    employee.scheduledWOStartDate = date
                }
                
                if let scheduledWOEndDate = valueDictionary[Constants.kkeyWOScheduleEndDate] as? String,
                    let date  = Utility.dateFromString(dateString: scheduledWOEndDate) {
                    employee.scheduledWOEndDate = date
                }
                
                let filterManager = FilterManager.sharedInstance
                
                //Domain
                if let domain = filterManager.filterCriteria[Constants.kkeyDomain], !domain.isEmpty {
                    for domainName in domain {
                        if let domainValue = valueDictionary[domainName] as? String, domainValue != kkeyNullValueString{
                            employee.domain[domainName] = domainValue
                        }
                    }
                }
                
                //SkillSet
                if let skillsSet = filterManager.filterCriteria[Constants.kkeySkillsSet] {
                    for skillsSetName in skillsSet {
                        if let skillsSetValue = valueDictionary[skillsSetName] as? String, skillsSetValue != kkeyNullValueString {
                            employee.skillsSet[skillsSetName] = skillsSetValue
                        }
                    }
                }
                
                //ToolsSet
                if let toolsSet = filterManager.filterCriteria[Constants.kkeyToolsSet] {
                    for toolsSetName in toolsSet {
                        if let toolsSetValue = valueDictionary[toolsSetName] as? String, toolsSetValue != kkeyNullValueString {
                            employee.toolsSet[toolsSetName] = toolsSetValue
                        }
                    }
                }
                
                //Certification
                if let certification = filterManager.filterCriteria[Constants.kkeyCertification] {
                    for certificationName in certification {
                        if let certificationValue = valueDictionary[certificationName] as? String, certificationValue != kkeyNullValueString {
                            employee.certification[certificationName] = certificationValue
                        }
                    }
                }
                
                //Insert into employeeData array
                self.employeeData.append(employee)
            }
        }
    }

    func getAllEmployeeData() -> [Employee] {
        return employeeData
    }
    
    func getAvailableEmployeeData() -> [Employee] {
        let predicate = NSPredicate(format:"self.allocation = %d", 0 )
        
        if let filteredArray = (employeeData as NSArray).filtered(using: predicate) as? [Employee] {
            return filteredArray
        }
        return [Employee]()
    }
    
    func getBookedEmployeeData() -> [Employee] {
        let predicate = NSPredicate(format:"self.%@ = %d","allocation",1 )
        
        if let filteredArray = (employeeData as NSArray).filtered(using: predicate) as? [Employee] {
            return filteredArray
        }
        
        return [Employee]()
    }
}
