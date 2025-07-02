//
//  MyDeviceProductRecordViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/24.
//

import UIKit
import RxSwift

class MyDeviceProductRecordViewController: CustomNavigationBarController {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
    let dataPicker = RecordTimeFilterViewController()
    let viewModel = MyDeviceProductRecordViewModel()
    
    let disposeBag = DisposeBag()
    
    init(deviceId: Int? = nil, productId: Int? = nil){
        super.init()
        self.viewModel.deviceId = deviceId
        self.viewModel.productId = productId
        let range = DateTool.getWeekRange()
        self.viewModel.startTime = range?.0
        self.viewModel.endTime = range?.1
        self.viewModel.getDeviceMetricsList()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        subscribe(disposeBag, self.viewModel.listDriver){ [weak self] data in
            self?.tableView.reloadData()
        }
    }
    
    @objc func rightButtonTouch(){
        self.selectTime()
    }
    
    func setUpViews(){
        self.title = "产能记录"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        
        self.navBar.rightBtn.isHidden = false
        let rightIma = UIImageView()
        rightIma.image = CommonIconFont.iconfontToImage(iconText: IconFontName.history.rawValue, fontSize: 20, fontColor: .blackColor33).image
        self.navBar.rightBtn.addSubview(rightIma)
        self.navBar.rightBtn.addTarget(self, action: #selector(rightButtonTouch), for: .touchUpInside)
        rightIma.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-5*CGFloat.widthSize())
            $0.centerY.equalTo(self.navBar.backIma)
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        view.addSubview(tableView)
        tableView.registerCell(forClass: MyDeviceProductRecordCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom)
        }
        
    }
    
    func selectTime(){
        currentDateCom = Calendar.current.dateComponents([.year, .month, .day], from: NSDate() as Date)
        if let startTime = self.viewModel.startTime{
            self.dataPicker.topView.leftDate.text = startTime
            self.dataPicker.leftDate = startTime
            let date = DateTool.dateFromString(timeFormat: .YYYYMMDD, date: startTime)
            currentDateCom = Calendar.current.dateComponents([.year, .month, .day], from: date as Date)
        }
        
        if let endTime = self.viewModel.endTime{
            self.dataPicker.topView.rightDate.text = endTime
            self.dataPicker.rightDate = endTime
        }
        
        dataPicker.backDate = { [weak self] date1,date2 in
            guard let `self` = self else {return}
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
            }else{
                if !compare2{
                    dateString2 = todayStr
                }
            }
            self.dataPicker.setDate(left: dateString1, right: dateString2)
            self.viewModel.startTime = dateString1
            self.viewModel.endTime = dateString2
            self.viewModel.getDeviceMetricsList()
        }
        dataPicker.onClear = { [weak self] in
            self?.viewModel.startTime = nil
            self?.viewModel.endTime = nil
            self?.viewModel.getDeviceMetricsList()
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

extension MyDeviceProductRecordViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MyDeviceProductRecordCell.self, for: indexPath)
        let item = self.viewModel.listRelay.value[indexPath.row]
        cell.bind(data: item)
        return cell
    }
}
