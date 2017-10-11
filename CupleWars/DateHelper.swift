//
//  DateHelper.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/29/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation

extension NSDate {
    
    func toString(dateFormat format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
}
