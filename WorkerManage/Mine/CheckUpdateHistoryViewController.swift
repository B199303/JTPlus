//
//  CheckUpdateHistoryViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/16.
//

import UIKit
import RxSwift

class CheckUpdateHistoryViewController: CustomNavigationBarController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let viewModel = CheckUpdateViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getHistory()
        initUI()
        
        subscribe(disposeBag, self.viewModel.historyDataDriver){ [weak self] list in
            self?.tableView.reloadData()
        }
    }
    

    func initUI(){
        self.title = "历史版本"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        view.backgroundColor = .whiteColorFA
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(forClass: CheckUpdateCell.self)
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    

}

extension CheckUpdateHistoryViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.historyDataRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CheckUpdateCell.self)
        let data = self.viewModel.historyDataRelay.value[indexPath.row]
        cell.bind(data: data)
        return cell
    }
}
