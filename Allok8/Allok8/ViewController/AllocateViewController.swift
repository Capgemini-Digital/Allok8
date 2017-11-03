//
//  AllocateViewController.swift
//  Allok8
//
//  Created by Test User 1 on 24/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AllocateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var activityIndicatorr: UIActivityIndicatorView!
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var toDateTextField: UITextField!
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var workOrderField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    var employee:Employee?
    var projectNamePicker = UIPickerView()
    var workOrderPicker = UIPickerView()
    let datePickerFromDate = UIDatePicker()
    let datePickerToDate = UIDatePicker()
    let pickerData = ["Next", "ANZ-NEXT-ID", "GROW", "Allok8"]
    let workOrderPickerData = ["1112", "1211"]
    
    enum TextFieldType:Int {
        case FromTextField = 21
        case ToTextField
        case ProjectTextField
        case WorkOrderTextField
    }
    
    var textFiledType:TextFieldType = .FromTextField
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = Constants.allocateScreenTitle
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backarrow"), style: .plain, target: self, action: #selector (backButtonTapped))
        
        submitButton.layer.cornerRadius = 3
        submitButton.layer.masksToBounds = false
        createPickers()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //formate date
        
        textFiledType = AllocateViewController.TextFieldType(rawValue: textField.tag)!
        print(textFiledType)
        datePickerFromDate.datePickerMode = .date
        datePickerToDate.datePickerMode = .date
    }
    
    func createPickers(){
        //formate date
        datePickerFromDate.datePickerMode = .date
        datePickerToDate.datePickerMode = .date
        datePickerToDate.backgroundColor = UIColor.groupTableViewBackground
        datePickerFromDate.backgroundColor = UIColor.groupTableViewBackground
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = Utility.blueColor()
        
        //UIPickerView
        self.projectNamePicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.projectNamePicker.delegate = self
        self.projectNamePicker.dataSource = self
        self.projectNamePicker.backgroundColor = UIColor.groupTableViewBackground

        self.workOrderPicker = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.workOrderPicker.delegate = self
        self.workOrderPicker.dataSource = self
        self.workOrderPicker.backgroundColor = UIColor.groupTableViewBackground

        
        //barbutton item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed(sender:)))
        doneButton.tintColor = UIColor.white
        toolbar.setItems([doneButton], animated: false)
        
        datePickerFromDate.minimumDate = Date()
        datePickerToDate.minimumDate = Date()
        fromDateTextField.inputAccessoryView = toolbar
        toDateTextField.inputAccessoryView = toolbar
        projectNameField.inputAccessoryView = toolbar
        workOrderField.inputAccessoryView = toolbar
        
        //assigning datepicker to textfield
        projectNameField.inputView = projectNamePicker
        fromDateTextField.inputView = datePickerFromDate
        toDateTextField.inputView = datePickerToDate
        workOrderField.inputView = workOrderPicker
    }
    
    func doneButtonPressed(sender: UIPickerView) {
        //date formatter
        let dateFormatterFromDate = DateFormatter()
        dateFormatterFromDate.dateStyle = .short
        dateFormatterFromDate.timeStyle = .none
        dateFormatterFromDate.dateFormat = Constants.dateFormat
        
        let dateFormatterToDate = DateFormatter()
        dateFormatterToDate.dateStyle = .short
        dateFormatterToDate.timeStyle = .none
        dateFormatterToDate.dateFormat = Constants.dateFormat
        
        switch textFiledType {
        case .FromTextField:
            fromDateTextField.text = dateFormatterFromDate.string(from: datePickerFromDate.date)
        case .ToTextField:
            toDateTextField.text = dateFormatterToDate.string(from: datePickerToDate.date)
        case .ProjectTextField:
            projectNameField.text = pickerData[projectNamePicker.selectedRow(inComponent: 0)]
        case .WorkOrderTextField:
            workOrderField.text = workOrderPickerData[workOrderPicker.selectedRow(inComponent: 0)]

        }
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Picker view delegate and datasource
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch textFiledType {
        case .ProjectTextField:
            return pickerData.count
        case .WorkOrderTextField:
            return workOrderPickerData.count
        default:
            return 0
        }

        return 0
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch textFiledType {
        case .ProjectTextField:
            return pickerData[row]
        case .WorkOrderTextField:
            return workOrderPickerData[row]
        default:
            return ""
        }
        return pickerData[row]
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let employeeReff = Database.database().reference(withPath: "Employee")
        let childRef = employeeReff.child((employee?.guId)!)
        activityIndicatorr.startAnimating()
        
        let updates:[String : Any] = [Constants.kkeyStartDate: fromDateTextField.text!, Constants.kkeyEndDate: toDateTextField.text!, Constants.kkeyProjectName: projectNameField.text!, Constants.kkeyAllocation: 1,
                                      Constants.kkeyWorkOrder: Int(workOrderField.text!)!]
        
        childRef.updateChildValues(updates, withCompletionBlock: { [weak self] (error: Error?, DatabaseReference) in
            
            if let _ = error {
                self?.activityIndicatorr.stopAnimating()
                print(error?.localizedDescription)
            }
            else {
                self?.perform(#selector (self?.notifyUpdateCompletion), with: nil, afterDelay: 6.0)
                
            }
        })
    }
    
    func notifyUpdateCompletion() {
        self.activityIndicatorr.stopAnimating()
        activityIndicatorr.stopAnimating()
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: Constants.RefreshEmployeeDataNotification)))
        
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController is UITabBarController {
                self.navigationController?.popToViewController(viewController, animated: true)
                break
            }
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
