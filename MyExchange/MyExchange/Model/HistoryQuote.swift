//
//  File.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/12/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation

struct HistoryQuote: Decodable {
    
    let base: String
    let rates: [[String: Double]]

    private enum CodingKeys: String, CodingKey {
        case base, rates
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        base = try container.decode(String.self, forKey: .base)

        let rawDatedRates = try container.decode([String: [String: Double]].self, forKey: .rates)

        var set = Set<Date>()
        
        for (key,_) in rawDatedRates {
            
            set.insert(key.toParamDate())
            
        }
        
        var sortedRates = [[String: Double]]()
        
        
        for date in set {
            
            guard let rawRates = rawDatedRates[date.paramString()] else {
                rates = []
                return
            }

            
            sortedRates.append(rawRates)
            
        }
        
        rates = sortedRates
        
    
    }
    
}
