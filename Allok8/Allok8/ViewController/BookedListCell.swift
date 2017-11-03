//
//  BookedListCell.swift
//  Allok8
//
//  Created by Test User 1 on 10/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

protocol expandCollapseDelegate:NSObjectProtocol {
    
    func expandCollapseAction(indexPath:NSIndexPath)
}

class BookedListCell: UITableViewCell {
    
    weak var delegate:expandCollapseDelegate?
  
    @IBOutlet weak var workOrder: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var expandCollapseImageView: UIImageView!

    @IBOutlet weak var mExpandCollapseButton: UIButton!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var projectName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func setData(employee: Employee) {
        employeeName.text = employee.name
        projectName.text = employee.projectName
        workOrder.text = employee.workOrder
        startDate.text = (employee.startDate != nil) ? Utility.stringFromDate(date:employee.startDate!) : Constants.kkeyNA
        endDate.text = (employee.endDate != nil) ? Utility.stringFromDate(date:employee.endDate!) : Constants.kkeyNA
    }
    
    @IBAction func expandCollpaseAction(_ sender: UIButton) {
        
       // sender.isSelected = !sender.isSelected
        let indexpath = NSIndexPath(row: sender.tag, section: 0)
        if(delegate != nil){
            delegate?.expandCollapseAction(indexPath: indexpath)
        }
    }
}
