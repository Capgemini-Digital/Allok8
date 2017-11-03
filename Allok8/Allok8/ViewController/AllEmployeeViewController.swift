//
//  BookedEmployeeVC.swift
//  Allok8
//
//  Created by Test User 1 on 10/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol FilterDataDelegate:NSObjectProtocol {
    func didSelectFilter(filterData: [String: String]);
}

class AllEmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, expandCollapseDelegate, FilterDataDelegate  {
    
    let kkeyExpandedRowHeight = 152
    let kkeyRowHeight = 60
    var isFilterSelected = false
    
    var employeeData = [Employee]()
    var filteredData = [Employee]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mBookedEmployeeTable: UITableView!
    var selectedIndexArray = NSMutableArray()
    let dataManager = DataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshEmployeeData()
        NotificationCenter.default.addObserver(self, selector: #selector (refreshEmployeeData), name: NSNotification.Name(rawValue: Constants.RefreshEmployeeDataNotification), object: nil)
    }
    
    public func populateEmployeeData() {
        self.employeeData.append(contentsOf: dataManager.getAllEmployeeData())
    }
    
    func refreshEmployeeData() {
        
        activityIndicator.startAnimating()
        let employeeReff = Database.database().reference(withPath: "Employee")
        
        employeeReff.observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            
            if let dictionary = snapshot.value as? NSDictionary {
                self?.activityIndicator.stopAnimating()
                self?.dataManager.initEmployeeArrayFromSnapshotDictionary(employeeSnapshot: dictionary)
                self?.employeeData.removeAll()
                self?.populateEmployeeData()
                self?.mBookedEmployeeTable.reloadData()
                print(self?.employeeData)
            }
        }
    }
    
    func didSelectFilter(filterData: [String : String]) {
        //Perform filter action and reload the data
        isFilterSelected = true
        print("Result", filterData)
        applyFilterLogic(filterData: filterData)
    }
    
    func applyFilterLogic(filterData: [String : String]) {
        var tempEmpArray =  employeeData as NSArray
        for (key,value) in filterData {
            
            var predicate: NSPredicate?
            if let _ = FilterManager.sharedInstance.filterCriteria[key] {
                
                filteredData = applyFilterForNonPropertyCriterias(key: key, value: value)
                mBookedEmployeeTable.reloadData()
                print(filteredData)
            }
            else {
                predicate = NSPredicate(format:"self.%@ = %@",key,value )
            }
            
            if let _ = predicate {
                let filteredArray = tempEmpArray.filtered(using: predicate!)
                tempEmpArray = filteredArray as NSArray 
                filteredData = filteredArray as! [Employee]
                mBookedEmployeeTable.reloadData()
                print(filteredArray)
                print(predicate)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
  
    // MARK: - Table View Datasource & Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = kkeyRowHeight
        if(selectedIndexArray .contains(indexPath)){
            height = kkeyExpandedRowHeight
        }
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "EmployeeInformation", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        if(isFilterSelected) {
            rowCount = filteredData.count
        }
        else {
            rowCount = employeeData.count
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.bookedCellIdentifier, for: indexPath) as! BookedListCell
        cell.delegate = self
        cell.mExpandCollapseButton.tag = indexPath.row
        if(isFilterSelected) {
            cell.setData(employee: filteredData[indexPath.row])
        }
        else {
            cell.setData(employee: employeeData[indexPath.row])
        }
        setExpandCollapseButton(aCell: cell, aIndex: indexPath)
        return cell
    }
    
    
    func setExpandCollapseButton(aCell:BookedListCell, aIndex:IndexPath)  {
        if(!selectedIndexArray .contains(aIndex)) {
          //  aCell.expandCollapseImageView.setImage(#imageLiteral(resourceName: "Down-Arrow"))
            aCell.expandCollapseImageView.image = #imageLiteral(resourceName: "Down-Arrow")
        }
        else {
            aCell.expandCollapseImageView.image = #imageLiteral(resourceName: "Up-Arrow")
           // aCell.mExpandCollapseButton.setImage(#imageLiteral(resourceName: "Up-Arrow"), for: .normal)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constants.employeeInformationScreenIdentifier {
            let indexPath = sender as! IndexPath
            let employeeInformationScreen = segue.destination as? EmployeeInformationViewController
            
            if isFilterSelected {
                employeeInformationScreen?.employeeData = filteredData[indexPath.row]
            } else {
                employeeInformationScreen?.employeeData = employeeData[indexPath.row]
            }
        }
        else if segue.identifier == Constants.filterScreenIdentifier {
            if let navigationController = segue.destination as? UINavigationController, navigationController.viewControllers.count > 0 {
                let filterViewController = navigationController.viewControllers[0] as? FilterSelectionViewController
                filterViewController?.delegate = self
            }
        }
    }
    
    func setNavigation()  {
        self.tabBarController?.navigationController!.isNavigationBarHidden = false
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated: false)
        self.tabBarController?.navigationItem.title = Constants.futureScreenTitle
        
        let appearance = UITabBarItem.appearance()
        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.lightGray]
        appearance.setTitleTextAttributes(attributes, for: .normal)

        let appearance1 = UITabBarItem.appearance()
        let attributes1: [String: AnyObject] = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 12.0), NSForegroundColorAttributeName: UIColor.white]
        appearance1.setTitleTextAttributes(attributes1, for: .selected)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector (filterButtonTapped))
        
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(AllEmployeeViewController.showAllEmployeeTapped))
    }
    
    func filterButtonTapped() {
        selectedIndexArray.removeAllObjects()
        mBookedEmployeeTable.reloadData()
        performSegue(withIdentifier: "filterScreen", sender: nil)
    }
    
    func showAllEmployeeTapped() {
        isFilterSelected = false
        mBookedEmployeeTable.reloadData()
    }
    
    func applyFilterForNonPropertyCriterias(key: String, value: String) -> [Employee] {
        var returnValue = false

        let filteredArray = employeeData.filter {
            switch key {
            //Domain
            case Constants.kkeyDomain:
                if let _ = $0.domain[value] {
                    returnValue = true
                }
            //SkillSet
            case Constants.kkeySkillsSet:
                if let _ = $0.skillsSet[value] {
                     returnValue = true
                }
            //ToolsSet
            case Constants.kkeyToolsSet:
                if let _ = $0.toolsSet[value] {
                     returnValue = true
                }
            //Certification
            case Constants.kkeyCertification:
                if let _ = $0.certification[value] {
                     returnValue = true
                }
            default:
                returnValue = false
            }
            return returnValue
        }
        return filteredArray
    }
    
    // MARK: - Table Cell Delegate
    
    func expandCollapseAction(indexPath:NSIndexPath) {
        if(selectedIndexArray.contains(indexPath)) {
            selectedIndexArray.remove(indexPath)
        }
        else {
            selectedIndexArray.add(indexPath)
        }
        mBookedEmployeeTable.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.RefreshEmployeeDataNotification), object: nil)
    }
}
