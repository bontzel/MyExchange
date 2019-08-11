//
//  HistoryViewModel.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/12/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation

struct HistoryViewModel {
 
    let sceneCoordinator: SceneCoordinatorType
    let exchangeService: ExchangeServiceType
    
    init(exchangeService: ExchangeServiceType, coordinator: SceneCoordinatorType) {
        
        self.exchangeService = exchangeService
        self.sceneCoordinator = coordinator
        
    }
    
}
