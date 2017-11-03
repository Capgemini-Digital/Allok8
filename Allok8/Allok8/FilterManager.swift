//
//  FilterManager.swift
//  Allok8
//
//  Created by Test User 1 on 27/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import Foundation

class FilterManager: NSObject {
    
    private var filterCriteriaDictionary = [String: [String]]()
    private static let sharedFilterManager = FilterManager()
    
    class var sharedInstance: FilterManager {
        if sharedFilterManager.filterCriteriaDictionary.isEmpty {
            sharedFilterManager.readFilterCriteriaJSON()
        }
        return sharedFilterManager
    }
    
    override init() {
        super.init()
    }
    
    private func readFilterCriteriaJSON() {
        do {
            if let file = Bundle.main.url(forResource: "FilterCriteria", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: [String]] {
                    // json is a dictionary
                    print(dictionary)
                    filterCriteriaDictionary = dictionary
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public var filterCriteria: [String: [String]] {
        if self.filterCriteriaDictionary.isEmpty {
            self.readFilterCriteriaJSON()
        }
        return filterCriteriaDictionary;
    }
}
