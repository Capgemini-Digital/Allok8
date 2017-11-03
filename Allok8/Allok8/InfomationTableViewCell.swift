//
//  InfomationTableViewCell.swift
//  Allok8
//
//  Created by Test User 1 on 24/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

class InfomationTableViewCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
