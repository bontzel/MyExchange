//
//  HistoryViewController.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/12/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import UIKit
import RxDataSources

class HistoryViewController: UIViewController, BindableType {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HistoryViewModel!
    
    var dataSource: RxTableViewSectionedReloadDataSource<HistorySection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 400
        self.configureDataSource()
    }
    
    func bindViewModel() {
        
        viewModel.allRates
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
        
    }
    
    private func configureDataSource() {
        
        dataSource = RxTableViewSectionedReloadDataSource<HistorySection>( configureCell: {
            dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
            cell.configure(with: item)
            
            return cell
        },
                                                                         titleForHeaderInSection: { dataSource, index in
                                                                            dataSource.sectionModels[index].model
        })
        
    }
    


}
