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
    fileprivate var timer = Observable<Int>.timer(0, period: 3, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    fileprivate var signal = PublishSubject<Int>()
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        
        
    }
    
    
    /// Latest quote for the preferred base currency
    var latestItems: Observable<[RatesSection]> {
        
        //get preferred inverval
        return self.interval.asObservable()
            //morph into datasource sections
            .flatMap({ (interval) -> Observable<[RatesSection]> in

                //create timer to tick at preferred interval
                let timer =  Observable<Int>.timer(0, period: interval, scheduler: MainScheduler.instance)
                    //need to dispose timer when new value is published
                    //do so when self.signal publishes value
                    .takeUntil(self.signal)

                return Observable.combineLatest(timer, self.base.asObservable())
                    //take last timer tick and latest currency preference
                    .flatMapLatest { (_, base) -> Observable<[RatesSection]> in

                        //do request
                        return self.exchangeService.latestQuote(for: base)
                            .map { quote in
                                RatesSection.init(model: quote.base, items: quote.rates)
                            }
                            //profit
                            .toArray()

                }

            })

    }
    
    
    func onSettings() -> CocoaAction {
        return CocoaAction { _ in
            
            let settingsViewModel = SettingsViewModel(exchangeService: self.exchangeService, coordinator: self.sceneCoordinator, currencyRelay: self.base, intervalRelay: self.interval, onUpdateCurrency: self.onUpdateCurrency(), endTimerSignal: self.signal)
            
            return self.sceneCoordinator
                .transition(to: Scene.settings(settingsViewModel), type: .push)
                .asObservable()
                .map { _ in }
            
        }
    }
    
    func onHistory() -> CocoaAction {
        return CocoaAction { _ in
            
            let historyViewModel = HistoryViewModel(exchangeService: self.exchangeService, coordinator: self.sceneCoordinator)
            return self.sceneCoordinator
                .transition(to: Scene.history(historyViewModel), type: .push)
                .asObservable()
                .map { _ in }
            
        }
    }
    
   
    func onUpdateCurrency() -> Action<String, Void> {
        return Action { newCurrency in
            self.base.accept(newCurrency)
            return Observable.empty()
        }
    }
    
    
    
    
    
}
