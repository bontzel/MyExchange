//
//  Scene+ViewController.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import Foundation
import UIKit

extension Scene {
    
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .home(let viewModel):
            
            let nc = storyboard.instantiateViewController(withIdentifier: "Home") as! UINavigationController
            var vc = nc.viewControllers.first as! HomeViewController
            vc.bindViewModel(to: viewModel)
            return nc
      
        }
    }
}
