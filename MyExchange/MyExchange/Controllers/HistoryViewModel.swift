//
//  HistoryViewModel.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/12/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

typealias RatesForCurrency = [String: [Double]]
typealias HistorySection = SectionModel<String, RatesForCurrency>


struct HistoryViewModel {
 
    let sceneCoordinator: SceneCoordinatorType
    let exchangeService: ExchangeServiceType
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        
    }
    
    /// Last 5 days history for RON, BGN and USD. Doesn't work well since we get 3 days from those 5 requested and I forgot to map which days from those 5 are the 3 that we get. 
    var allRates: Observable<[HistorySection]> {
                
         return Observable.merge(self.exchangeService.lastFiveDaysHistory(for: "RON"), self.exchangeService.lastFiveDaysHistory(for: "USD"), self.exchangeService.lastFiveDaysHistory(for: "BGN"))
            //get all the values from the given time for each symbol and the base currency. i.e: (["EUR": [1.5, 2.23, 2.55], "RON": [1.5, 2.23, 2.55]...], "BGN")
            .flatMap { (historyQuote) -> Observable<(RatesForCurrency, String)> in
               
                //get all the symbols
                return self.exchangeService.symbols()
                    .flatMap { array -> Observable<String> in
                        return Observable.from(array)
                    }
                    //get all the values from each day for a symbol. i.e: ([1.5, 2.23, 2.55], "EUR")
                    .flatMap { (symbol) -> Observable<(([Double], String))> in
                        
                        guard symbol != historyQuote.base else {
                            return Observable<(([Double], String))>.empty()
                        }
                        
                        var array = [Double]()
                        for day in historyQuote.rates {
                            array.append(day[symbol] ?? 0.0)
                        }
                        
                        return Observable.just((array, symbol))
                        
                    }
                    //get them all. i.e: [([1.5, 2.23, 2.55], "EUR"), ([1.5, 2.23, 2.55], "RON")...]
                    .toArray()
                    //morph to dictionary and pair with base. i.e: (["EUR": [1.5, 2.23, 2.55], "RON"...], "BGN")
                    .flatMap { (array) -> Observable<(RatesForCurrency, String)> in
                    
                        var rates = RatesForCurrency()
                        for item in array {
                            rates[item.1] = item.0
                        }
                        
                        return Observable.just((rates, historyQuote.base))
                    }
            
                
            }
            //get all 3 of them in the previous form
            .toArray()
            //morph to section items
            .flatMap { (items) -> Observable<[HistorySection]> in
             
                var sectionsArray = [HistorySection]()
                
                for item in items {
                    sectionsArray.append(HistorySection.init(model: item.1, items: [item.0]))
                }
                //profit
                return Observable.of(sectionsArray)
                
            }
        
    }
    
}
