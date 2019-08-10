//
//  File.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/10/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation

extension Date {
    
    func timeStampString() -> String {
        
        let df = DateFormatter.init()
        
        df.dateFormat = "HH:mm:ss dd-MMM-YYYY"
        
        return df.string(from: self)
        
    }
    
}
