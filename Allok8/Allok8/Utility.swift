//
//  Uility.swift
//  Allok8
//
//  Created by Test User 1 on 17/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    static var dateFormatter:DateFormatter {
        let dateFormtr = DateFormatter()
        dateFormtr.dateFormat = Constants.dateFormat
        return dateFormtr
    }
    
    class func dateFromString(dateString: String) -> Date? {
        if dateString.isEmpty {
            return nil
        }
        
        return dateFormatter.date(from: dateString)!
    }
    
    class func stringFromDate(date: Date?) -> String? {
        if let _ = date {
            return dateFormatter.string(from: date!)
        }
        
        return nil
    }
    
    class func showWorkProgressAlert() -> UIAlertController {
        let alertView = UIAlertController(title: "Alert", message: "Coming Soon", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
        alertView.addAction(action)
        return alertView
    }
    
    class func blueColor() -> UIColor {
        let blueColor = UIColor.init(colorLiteralRed: 22/255, green: 146/255, blue: 181/255, alpha: 1.0)
        return blueColor
    }
}
