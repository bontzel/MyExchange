//
//  RatesTableViewCell.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/10/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import UIKit

class RatesTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    func configure(with rates: Rates) {
        
        self.label.text = "\(rates.0): \(rates.1)"
        
    }

}
