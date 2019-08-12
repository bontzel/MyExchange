//
//  HistoryTableViewCell.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/12/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import UIKit
import Charts

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lineChart: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with rates: RatesForCurrency) {
        
        let data: LineChartData = LineChartData()
        
        for (currency, values) in rates {
            
            var entry = [ChartDataEntry]()
            
            for i in 0..<values.count {
                entry.append(ChartDataEntry.init(x: Double(i), y: values[i]))
            }
                        
            data.addDataSet(LineChartDataSet.init(entries: entry, label: currency))
            
        }
        
        lineChart.data = data
        
    }

}
