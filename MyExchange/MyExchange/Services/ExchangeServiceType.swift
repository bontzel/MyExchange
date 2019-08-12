//
//  ExchangeServiceType.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import RxSwift

enum ExchangeServiceError: Error {
    case someError
}

protocol ExchangeServiceType {
    
    @discardableResult
    func latestQuote(for currency: String) -> Observable<Quote>
    
    @discardableResult
    func symbols() -> Observable<[String]>
    
    @discardableResult
    func lastFiveDaysHistory(for currency: String) -> Observable<HistoryQuote>
    
    
}
