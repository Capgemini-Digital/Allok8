//
//  FilterSelectionViewController.swift
//  Allok8
//
//  Created by Test User 1 on 18/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

class FilterSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterCategoryTableview: UITableView!
    @IBOutlet weak var filterValuesTableview: UITableView!
    
    var filterValueDictionary = [FilterValue]()
    var selectedFilterCategory: Int = 0
    var selectedFilterDictionary = [String: String]()
    let filterCategoryCellIdentifier = "FilterCategoryCell"
    let filterValueCellIdentifier = "FilterValueCell"
    var previousSelectedIndex:IndexPath?
    
    weak var delegate:FilterDataDelegate?
   // let slectedFilterCategoryCell:FilterCategoryCellTableViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.populateFilterData()
        filterButton.layer.cornerRadius = 3
        filterButton.layer.masksToBounds = false
        self.filterValuesTableview.tintColor = Utility.blueColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelClicked(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func applyFilterClicked(_ sender: AnyObject) {
        delegate?.didSelectFilter(filterData: self.selectedFilterDictionary)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table View Datasource & Delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.filterCategoryTableview {
            return filterValueDictionary.count
        }
        else if tableView == self.filterValuesTableview {
            var valuesArray = [String]()
            if self.filterValueDictionary.count > 0 {
                let filterValue = self.filterValueDictionary[self.selectedFilterCategory]
                valuesArray = filterValue.values
                
            }
            
            return valuesArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.filterCategoryTableview {
            let cell  = tableView.dequeueReusableCell(withIdentifier: filterCategoryCellIdentifier, for: indexPath) as? FilterCategoryCellTableViewCell
            let filterValue = self.filterValueDictionary[indexPath.row]
            cell?.nameLabel.text = filterValue.filterDisplayName
            
            if(indexPath.row == 0){
                cell?.nameLabel.textColor = Utility.blueColor()
            }
            
            return cell!
        }
        else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: filterValueCellIdentifier, for: indexPath) as? FilterValueSelectionCell
            let filterValue = self.filterValueDictionary[self.selectedFilterCategory]
            cell?.valueName.text = filterValue.values[indexPath.row]
            
            if self.isFilterValueSelected(filterData: filterValue, value: filterValue.values[indexPath.row]) {
                cell?.accessoryType = .checkmark
                previousSelectedIndex = indexPath
                
            }
            else {
                cell?.accessoryType = .none
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.filterCategoryTableview {
            tableView.deselectRow(at: indexPath, animated: false)
            let previousSelectedCell = filterCategoryTableview.cellForRow(at:IndexPath(row: self.selectedFilterCategory, section: 0)) as! FilterCategoryCellTableViewCell
            previousSelectedCell.nameLabel.textColor = UIColor.black
            self.selectedFilterCategory = indexPath.row
            
            let cell = filterCategoryTableview.cellForRow(at: indexPath) as! FilterCategoryCellTableViewCell
            cell.nameLabel.textColor = Utility.blueColor()
            self.filterValuesTableview.reloadData()
        }
        else if tableView == self.filterValuesTableview {
            if let _ = previousSelectedIndex, let cell = tableView.cellForRow(at: previousSelectedIndex!) {
                cell.accessoryType = .none
            }
            
            if let cell  = tableView.cellForRow(at: indexPath) as? FilterValueSelectionCell {
                
                let filterData = self.filterValueDictionary[self.selectedFilterCategory]
                
                if self.isFilterSelected(filterData: filterData) {
                    //Remove the record from selectedFilterDictionary
                    self.selectedFilterDictionary[filterData.filterKey] = nil
                }
                else {
                    //Add the record
                    self.selectedFilterDictionary[filterData.filterKey] = filterData.values[indexPath.row]
                }
                
                cell.accessoryType = .checkmark
            }
        }
    }
    
    
    func isFilterSelected(filterData: FilterValue) -> Bool {
        for (key, _) in self.selectedFilterDictionary {
            if key == filterData.filterKey {
                return true
            }
        }
        return false
    }
    
    func isFilterValueSelected(filterData: FilterValue, value: String) -> Bool {
        for (key, val) in self.selectedFilterDictionary {
            if key == filterData.filterKey && value == val {
                return true
            }
        }
        return false
    }

    func populateFilterData() {
        let filterManager = FilterManager.sharedInstance
        
        for (key, value) in filterManager.filterCriteria {
            let filterWO = FilterValue()
            filterWO.filterKey = key
            filterWO.filterDisplayName = key
            filterWO.values = value
            self.filterValueDictionary.append(filterWO)
        }
        
        let filterWO = FilterValue()
        filterWO.filterKey = "workOrder"
        filterWO.filterDisplayName = "Work Order"
        filterWO.values = ["1112", "1511"]
        self.filterValueDictionary.append(filterWO)
        
        let filterDomain = FilterValue()
        filterDomain.filterKey = "resourceLocation"
        filterDomain.filterDisplayName = "Location"
        filterDomain.values = ["Bangalore PSN", "Bangalore Ecospace", "Australia"]
        self.filterValueDictionary.append(filterDomain)
        
        let filterSkills = FilterValue()
        filterSkills.filterKey = "WOOwner"
        filterSkills.filterDisplayName = "Project Manager"
        filterSkills.values = ["Cersi Lannister", "Jon Snow", "Josh Duhamel"]
        self.filterValueDictionary.append(filterSkills)
        
        let filterProjectName = FilterValue()
        filterProjectName.filterKey = "projectName"
        filterProjectName.filterDisplayName = "Project Name"
        filterProjectName.values = ["Next", "ANZ-NEXT-ID", "GROW"]
        self.filterValueDictionary.append(filterProjectName)
    }
}
