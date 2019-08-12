//
//  SettingsViewModel.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/10/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxRelay
import RxDataSources

typealias SymbolsSection = SectionModel<String, String>

struct SettingsViewModel {

    let sceneCoordinator: SceneCoordinatorType
    let exchangeService: ExchangeServiceType
    let currencyRelay: BehavoirRelay<String>
    let intervalRelay: BehavoirRelay<RxTimeInterval>
    let onUpdateCurrency: Action<String, Void>
    let endTimerSignal: PublishSubject<Int>
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType, currencyRelay: BehavoirRelay<String>, intervalRelay: BehavoirRelay<RxTimeInterval>, onUpdateCurrency: Action<String, Void>, endTimerSignal: PublishSubject<Int>) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        self.currencyRelay = currencyRelay
        self.intervalRelay = intervalRelay
        self.onUpdateCurrency = onUpdateCurrency
        self.endTimerSignal = endTimerSignal
        
    }
    
    var intervals: Observable<[RxTimeInterval]> {
        return Observable.just([3, 5, 15])
    }
    
    var symbols: Observable<[SymbolsSection]> {
        return self.exchangeService.symbols()
            .map { symbols in
                SymbolsSection.init(model: "Change current base currency:", items: symbols)
            }
            .toArray()
    }
    
    
    
    
    
}
