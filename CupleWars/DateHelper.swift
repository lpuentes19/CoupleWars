//
//  DateHelper.swift
//  CupleWars
//
//  Created by Luis Puentes on 9/29/17.
//  Copyright © 2017 LuisPuentes. All rights reserved.
//

import Foundation

extension Date {
    
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
}
