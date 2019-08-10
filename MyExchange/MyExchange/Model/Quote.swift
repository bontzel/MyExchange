//
//  Quote.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import RxDataSources

typealias Rates = (String, Double)

struct Quote: Decodable {
    
    let base: String
    let date: String
    let rates: [Rates]
    
    private enum CodingKeys: String, CodingKey {
        case base, date, rates
    }
    
    init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        base = try container.decode(String.self, forKey: .base)
        date = try container.decode(String.self, forKey: .date)
        let rawRates = try container.decode([String: Double].self, forKey: .rates)
       
        var array = [Rates]()
        for (key, value) in rawRates {
            array.append(Rates(key, value))
        }
        
        rates = array
        
    }
    
}
