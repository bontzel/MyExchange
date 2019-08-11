//
//  ExchangeService.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import RxSwift

struct ExchangeService: ExchangeServiceType {
        
    func latestQuote(for currency: String) -> Observable<Quote> {
        return ExchangeAPI.latest(for: currency)
    }
    
    func symbols() -> Observable<[String]> {
        return ExchangeAPI.symbols
    }
    
}
