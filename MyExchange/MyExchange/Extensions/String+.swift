//
//  String+.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/12/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation

extension String {
    
    func toParamDate() -> Date {
    
        let df = DateFormatter.init()
        
        df.dateFormat = "YYYY-MM-dd"
        
        return df.date(from: self) ?? Date()
        
    }
    
}
