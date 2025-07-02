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
        self.viewModel.getAlarmList()
        initUI()
        
        subscribe(disposeBag, viewModel.listDriver){[weak self] data in
            self?.collectionView.reloadData()
        }
    }
    
    func initUI(){
        self.title = "告警"
        navBar.isHidden = false
        self.view.backgroundColor = .grayColorEF
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
        let vc = MyDeviceAlarmListViewController(deviceId: item.deviceId)
        self.navigationController?.pushViewController(vc)
    }
    
}


