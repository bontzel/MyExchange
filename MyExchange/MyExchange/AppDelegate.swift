//
//  AppDelegate.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let service = ExchangeService()
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let homeViewModel = HomeViewModel.init(exchangeService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.home(homeViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        
        return true
    }

   


}

