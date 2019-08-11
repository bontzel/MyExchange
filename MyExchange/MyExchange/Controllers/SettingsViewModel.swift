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

struct SettingsViewModel {

    let sceneCoordinator: SceneCoordinatorType
    let exchangeService: ExchangeServiceType
    let currencyRelay: BehavoirRelay<String>
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType, currencyRelay: BehavoirRelay<String>) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        self.currencyRelay = currencyRelay
        
    }
    
    
    
    
    
}
