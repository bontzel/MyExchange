//
//  SettingsViewController.swift
//  MyExchange
//
//  Created by Cosmin Bonta on 8/10/19.
//  Copyright © 2019 Cosmin Bonta. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SettingsViewController: UIViewController, BindableType {
    
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeIntervalButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var viewModel: SettingsViewModel!
    
    var dataSource: RxTableViewSectionedReloadDataSource<SymbolsSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.changeIntervalButton.rx.tap
            .throttle(1, scheduler: MainScheduler.instance)
            .map { _ in
                return !self.pickerView.isHidden
            }
            .asDriver(onErrorJustReturn: true)
            .drive(self.pickerView.rx.isHidden)
            .disposed(by: self.rx.disposeBag)
        
        configureDataSource()
    }

    func bindViewModel() {
        
        viewModel.intervalRelay
            .asObservable()
            .flatMap { (interval) -> Observable<String> in
                return Observable.of("Refresh Interval: \(interval)")
            }
            .asDriver(onErrorJustReturn: "")
            .drive(self.refreshLabel.rx.text)
            .disposed(by: self.rx.disposeBag)
        
        viewModel.symbols
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.rx.disposeBag)
        
        
        guard let vm = viewModel else { return }
        
        viewModel.intervals.bind(to: self.pickerView.rx.itemTitles) { _, item in
            return "\(item)"
        }
        .disposed(by: self.rx.disposeBag)
        
        self.pickerView.rx.modelSelected(RxTimeInterval.self)
            .subscribe(
                onNext: { interval in
                        vm.intervalRelay.accept(interval.last ?? 3)
                }
            )
            .disposed(by: self.rx.disposeBag)
        
        self.tableView.rx
            .itemSelected
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! String
            }
            .bind(to: viewModel.onUpdateCurrency.inputs)
            .disposed(by: self.rx.disposeBag)

        
        
    }
    
    private func configureDataSource() {
        
        dataSource = RxTableViewSectionedReloadDataSource<SymbolsSection>(
            configureCell: {
                dataSource, tableView, indexPath, item in
                
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                cell.textLabel?.text = item
                return cell
        },
            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            }
        )
        
    }
    
    
}
