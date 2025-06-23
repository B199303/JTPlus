//
//  MyDeviceNoticeViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/22.
//

import UIKit
import RxSwift

class MyDeviceNoticeViewController: CustomNavigationBarController {
    private let contentCellID = "contentCellID"
    
    lazy var collectionView : UICollectionView = {
        //设置布局
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemSpac = CGFloat.widthSize()
        layout.scrollDirection = .vertical
        let width = (CGFloat.screenWidth - 60*CGFloat.widthSize())/2
        layout.itemSize = CGSize.init(width: width, height: width)
        layout.minimumInteritemSpacing = itemSpac //item 间距
        layout.minimumLineSpacing = 18*CGFloat.widthSize()
        layout.sectionInset = .init(top: 18*CGFloat.widthSize(), left: 20*CGFloat.widthSize(), bottom: 18*CGFloat.widthSize(), right: 20*CGFloat.widthSize())
        
        let collectView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = .clear
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.isScrollEnabled = true
        collectView.isUserInteractionEnabled = true
        collectView.register(MyDeviceNoticeContentCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectView
    }()
    
    let viewModel = MyDeviceNoticeViewModel()
    let disposeBag = DisposeBag()
    
    private var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
    let dataPicker = RecordTimeFilterViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getAlarmList(loadMore: false)
        initUI()
        
        subscribe(disposeBag, viewModel.listDriver){[weak self] data in
            self?.collectionView.reloadData()
        }
        
        subscribe(disposeBag, viewModel.noMoreDataDriver) { [weak self] noMoreData in
            if noMoreData {
                self?.collectionView.mj_footer?.endRefreshingWithNoMoreData()
            } else {
                self?.collectionView.mj_footer?.resetNoMoreData()
            }
            self?.collectionView.mj_footer?.isHidden = noMoreData
        }
        
        subscribe(disposeBag, viewModel.endRefreshDriver) { [weak self] _ in
            self?.collectionView.mj_header?.endRefreshing(completionBlock: {
                self?.collectionView.reloadData()
            })
        }
    }
    
    @objc func rightButtonTouch(){
        self.selectTime()
    }
    
    func initUI(){
        self.title = "告警"
        navBar.isHidden = false
        self.view.backgroundColor = .grayColorEF
        
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
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.mj_header = RefreshHeader(refreshingBlock: { [weak self] in
            guard let `self` = self else {return}
            self.viewModel.getAlarmList(loadMore: false)
        })
        
        collectionView.mj_footer = RefreshFooter(refreshingBlock: { [weak self] in
            guard let `self` = self else {return}
            self.viewModel.getAlarmList(loadMore: true)
        })
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
//            self.topView.filterTime.isHidden = false
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
//                self.topView.filterTime.text = todayStr
            }else{
                if !compare2{
                    dateString2 = todayStr
                }
//                self.topView.filterTime.text = "\(dateString1)至\(dateString2)"
            }
            self.dataPicker.setDate(left: dateString1, right: dateString2)
            self.viewModel.startTime = dateString1
            self.viewModel.endTime = dateString2
            self.viewModel.getAlarmList(loadMore: false)
        }
        dataPicker.onClear = { [weak self] in
//            self?.topView.filterTime.isHidden = true
            self?.viewModel.startTime = nil
            self?.viewModel.endTime = nil
            self?.viewModel.getAlarmList(loadMore: false)
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

extension MyDeviceNoticeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.listRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath) as! MyDeviceNoticeContentCell
        let item = self.viewModel.listRelay.value[indexPath.row]
        cell.bind(data: item)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.viewModel.listRelay.value[indexPath.row]
        self.navigationController?.pushViewController(MyDeviceDetailViewController(deviceId: item.deviceId))
    }
    
}


