//
//  EmployeeInformationViewController.swift
//  Allok8
//
//  Created by Test User 1 on 19/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EmployeeInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allocateButton: UIButton!
    var employeeData = Employee()
    let keyArray = ["Employee Id :", "Employee Name :", "Project Name :", "Location :", "Work Order :", "WO Owner :","Skills Set :","Certifications :","Domain :","Tools Set :", "Start Date :", "End Date :"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        allocateButton.layer.cornerRadius = 3
        allocateButton.layer.masksToBounds = false
        self.navigationItem.title = Constants.employeeInformationScreenTitle
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backarrow"), style: .plain, target: self, action: #selector (backButtonTapped))
        
        if let allocation = employeeData.allocation?.intValue
        {
            if(allocation > 0){
                allocateButton.setTitle("Release", for: .normal)
            }
            else {
                allocateButton.setTitle("Allocate", for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfomationTableViewCell", for: indexPath) as! InfomationTableViewCell
        populateCellData(indexPath: indexPath, cell: cell)
        return cell
    }
    
    func populateCellData(indexPath:IndexPath, cell:InfomationTableViewCell) {
        switch indexPath.row {
        case 0:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = employeeData.employeeId
        case 1:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = employeeData.name
            //        case 2:
            //            cell.key.text = keyArray[indexPath.row]
        //            cell.value.text = String(describing: employeeData.allocation)
        case 2:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = employeeData.projectName
        case 3:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = employeeData.resourceLocation
        case 4:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = employeeData.workOrder
        case 5:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = employeeData.WOOwner
        case 6:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = populateSkillSetToolSetDomain(aDict: employeeData.skillsSet)
            print(employeeData.domain)
        case 7:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = populateCertification(aDict: employeeData.certification)
        case 8:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = populateSkillSetToolSetDomain(aDict: employeeData.domain)
        case 9:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = populateSkillSetToolSetDomain(aDict: employeeData.toolsSet)
        case 10:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = (employeeData.startDate != nil) ? Utility.stringFromDate(date:employeeData.startDate!) : Constants.kkeyNA
        case 11:
            cell.key.text = keyArray[indexPath.row]
            cell.value.text = (employeeData.endDate != nil) ? Utility.stringFromDate(date:employeeData.endDate!) : Constants.kkeyNA
        default:
            print("No result found")
        }
    }
    
    func populateSkillSetToolSetDomain(aDict:[String:String]) -> String {
        var string = ""
        for (key, value) in aDict {
            if(value == "Beginner" || value == "Intermediate" || value == "Expert"){
                string = string + key + ", "
            }
        }
        
        if string.characters.count > 2 {
            let endIndex = string.index(string.endIndex, offsetBy: -2)
            let truncated = string.substring(to: endIndex)
            return truncated
        }
        
        return truncateEndCharacters(string: string)
    }
    
    func populateCertification(aDict:[String:String]) -> String {
        var string = ""
        for (key, value) in aDict {
            if(value == "yes"){
                string = string + key + ", "
            }
        }
        
        return truncateEndCharacters(string: string)
    }
    
    func truncateEndCharacters(string: String) -> String {
        if string.characters.count > 2 {
            let endIndex = string.index(string.endIndex, offsetBy: -2)
            let truncated = string.substring(to: endIndex)
            return truncated
        }
        
        return string
    }
    
    @IBAction func allocateButtonPressed(_ sender: AnyObject) {
        if allocateButton.titleLabel?.text == "Allocate" {
            performSegue(withIdentifier: "AllocateScreen", sender: self)
        }
        else {
            let employeeReff = Database.database().reference(withPath: "Employee")
            let childRef = employeeReff.child((employeeData.guId)!)
            activityIndicator.startAnimating()
            let updates:[String : Any] = [Constants.kkeyStartDate: "", Constants.kkeyEndDate: "", Constants.kkeyProjectName: "", Constants.kkeyAllocation: 0, Constants.kkeyWorkOrder: 0]
            
            childRef.updateChildValues(updates, withCompletionBlock: { [weak self] (error: Error?, DatabaseReference) in
                if let _ = error {
                    print(error?.localizedDescription)
                    self?.activityIndicator.stopAnimating()
                }
                else {
                    self?.perform(#selector (self?.notifyUpdateCompletion), with: nil, afterDelay: 6.0)
                }
            })
        }
    }
    
    func notifyUpdateCompletion() {
        activityIndicator.stopAnimating()
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: Constants.RefreshEmployeeDataNotification)))
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AllocateScreen" {
            let destinationController = segue.destination as! AllocateViewController
            destinationController.employee = employeeData
        }
    }
}
