//
//  Quote.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation

typealias Rates = [String: String]

struct Quote: Decodable {
    
    let base: String
    let date: Date
    let rates: Rates
    
    private enum CodingKeys: String, CodingKey {
        case base, date, rates
    }
    
    init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        base = try container.decode(String.self, forKey: .base)
        date = try container.decode(Date.self, forKey: .date)
        rates = try container.decode(Rates.self, forKey: .rates)
    }
    
}
