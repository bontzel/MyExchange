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
    
    //could not find endpoint to get all symbols on https://exchangeratesapi.io/
    func symbols() -> Observable<[String]> {
        return Observable.just(["USD", "RON", "EUR"])
    }
    
}
