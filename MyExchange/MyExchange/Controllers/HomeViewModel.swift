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
import RxRelay

typealias RatesSection = SectionModel<String, Rates>

struct HomeViewModel {
    
    let sceneCoordinator: SceneCoordinatorType
    let exchangeService: ExchangeServiceType
    
    fileprivate var base: BehavoirRelay<String> = BehavoirRelay<String>(defaultValue: "EUR")
    fileprivate var interval: BehavoirRelay<RxTimeInterval> = BehavoirRelay<RxTimeInterval>(defaultValue: 3)
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        
        
    }
    
    
    var latestItems: Observable<[RatesSection]> {
        
        return self.interval.asObservable()
            .flatMap({ (interval) -> Observable<[RatesSection]> in
                
                let timer =  Observable<Int>.timer(0, period: interval, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                
                return Observable.combineLatest(timer, self.base.asObservable())
                    .flatMap { (_, base) -> Observable<[RatesSection]> in
                        
                        return self.exchangeService.latestQuote(for: base)
                            .map { quote in
                                RatesSection.init(model: quote.base, items: quote.rates)
                            }
                            .toArray()
                        
                }
                
            })
        
    }
    
    
    func onSettings() -> CocoaAction {
        return CocoaAction { _ in
            
            let settingsViewModel = SettingsViewModel(exchangeService: self.exchangeService, coordinator: self.sceneCoordinator, currencyRelay: self.base)
            return self.sceneCoordinator
                .transition(to: Scene.settings(settingsViewModel), type: .push)
                .asObservable()
                .map { _ in }
            
        }
    }
    
    
    
    
    
    
}
