//
//  HomeViewController.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/9/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import NSObject_Rx



class HomeViewController: UIViewController, BindableType {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    
    var viewModel: HomeViewModel!
    
    var dataSource: RxTableViewSectionedReloadDataSource<RatesSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        
    }
    
    func bindViewModel() {
        
        
        viewModel.latestItems
            .do(
                onNext: { _ in
                    self.timestampLabel.text = Date().timeStampString()
            })
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
        

        self.settingsButton.rx.action = viewModel.onSettings()
       
        
    }
    
    private func configureDataSource() {
        
        dataSource = RxTableViewSectionedReloadDataSource<RatesSection>( configureCell: {
            dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatesCell", for: indexPath) as! RatesTableViewCell
            cell.configure(with: item)

            return cell
            },
                                                                         titleForHeaderInSection: { dataSource, index in
                                                                            dataSource.sectionModels[index].model
        })
        
    }
    
    
}
