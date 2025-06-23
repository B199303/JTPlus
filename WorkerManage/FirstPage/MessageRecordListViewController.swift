//
//  MessageRecordListViewController.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/21.
//

import UIKit
import RxSwift

class MessageRecordListViewController: CustomNavigationBarController {
    let topView = MessageTopView()
    let tableView = UITableView(frame: .zero, style: .plain)
    let viewModel = MessageViewModel()
    let disposeBag = DisposeBag()
    
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
    let dataPicker = RecordTimeFilterViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getList(loadMore: false)
        
        subscribe(disposeBag, self.viewModel.listDriver){[weak self] data in
            self?.tableView.reloadData()
        }
        
        subscribe(disposeBag, viewModel.endRefreshDriver) { [weak self] _ in
            self?.tableView.mj_header?.endRefreshing(completionBlock: {
                self?.tableView.reloadData()
            })
        }
        
        subscribe(disposeBag, viewModel.noMoreDataDriver) { [weak self] noMoreData in
            if noMoreData {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self?.tableView.mj_footer?.resetNoMoreData()
            }
            self?.tableView.mj_footer?.isHidden = noMoreData
        }

        setUpViews()
    }
    
    func setUpViews(){
        self.title = "消息"
        navBar.isHidden = false
        navBar.bottomLine.isHidden = true
        navBar.backgroundColor = .clear
        view.backgroundColor = .blackColor16
        
        topView.filterIma.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else {return}
            self.selectTime()
        }).disposed(by: disposeBag)
        view.addSubview(topView)
        topView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(72)
        }
        
        view.addSubview(tableView)
        tableView.registerCell(forClass: MessageRecordListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .blackColor27
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        
        tableView.mj_header = RefreshHeader(refreshingBlock: { [weak self] in
            self?.viewModel.getList(loadMore: false)
        })
        
        tableView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            self?.viewModel.getList(loadMore: true)
        })
        
        self.topView.inputTextField.rx.controlEvent([.editingDidEnd]).asObservable()
            .subscribe(onNext:{[weak self] in
                guard let `self` = self else {return}
                if let text = self.topView.inputTextField.text{
                    self.viewModel.query = text
                }else{
                    self.viewModel.query = nil
                }
                self.viewModel.getList(loadMore: false)
            })
            .disposed(by: disposeBag)
    }
    
    func selectTime(){
        currentDateCom = Calendar.current.dateComponents([.year, .month, .day], from: NSDate() as Date)
        if let startTime = self.viewModel.startTime{
            self.dataPicker.topView.leftDate.text = startTime
            self.dataPicker.leftDate = startTime
            let date = DateTool.dateFromString(timeFormat: .YYYYMMDD, date: startTime)
            currentDateCom = Calendar.current.dateComponents([.year, .month, .day], from: date as Date)
        }
        
        dataPicker.backDate = { [weak self] date1,date2 in
            guard let `self` = self else {return}
            self.topView.filterTime.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            var dateString1: String = dateFormatter.string(from: date1)
            var dateString2: String = dateFormatter.string(from: date2)
            let compare = DateTool.compare(start: dateString1, end: dateString2)
            if !compare{
                let temp = dateString1
                dateString1 = dateString2
                dateString2 = temp
            }
            let todayStr:String = dateFormatter.string(from: Date())
            let compare2 = DateTool.compare(start: dateString2, end: todayStr)
            
            if date1 == date2{
                if !compare2{
                    dateString1 = todayStr
                    dateString2 = todayStr
                }
                self.topView.filterTime.text = todayStr
            }else{
                if !compare2{
                    dateString2 = todayStr
                }
                self.topView.filterTime.text = "\(dateString1)至\(dateString2)"
            }
            self.dataPicker.setDate(left: dateString1, right: dateString2)
            self.viewModel.startTime = dateString1
            self.viewModel.endTime = dateString2
            self.viewModel.getList(loadMore: false)
        }
        dataPicker.onClear = { [weak self] in
            self?.topView.filterTime.isHidden = true
            self?.viewModel.startTime = nil
            self?.viewModel.endTime = nil
            self?.viewModel.getList(loadMore: false)
        }
        dataPicker.view.frame = CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: CGFloat.screenHeight)
        dataPicker.rowarr = [2,(self.currentDateCom.month!) - 1,(self.currentDateCom.day!) - 1]
        dataPicker.picker.reloadAllComponents()
        /// 弹出时日期滚动到当前日期效果
        self.present(dataPicker, animated: false) {
            self.dataPicker.picker.selectRow(2, inComponent: 0, animated: false)
            self.dataPicker.picker.selectRow((self.currentDateCom.month!) - 1, inComponent: 1, animated:   false)
            self.dataPicker.picker.selectRow((self.currentDateCom.day!) - 1, inComponent: 2, animated: false)
        }
    }
}

extension MessageRecordListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.alarmList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MessageRecordListCell.self, for: indexPath)
        cell.bind(data: self.viewModel.alarmList[indexPath.row])
        return cell
    }
}
