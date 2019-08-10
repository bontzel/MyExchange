//
//  HomeViewModel.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias RatesSection = SectionModel<String, Rates>

struct HomeViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let exchangeService: ExchangeServiceType
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        
    }
    
    var latestItems: Observable<[RatesSection]> {
        
        return Observable<Int>.timer(0, period: 3, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { _ -> Observable<[RatesSection]> in
                
                return self.exchangeService.latestQuote(for: "")
                    .map { quote in
                        
                        RatesSection.init(model: quote.base, items: quote.rates)
                        
                    }
                    .toArray()

        }
        
    }
    
    
    
}
