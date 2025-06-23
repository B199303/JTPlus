//
//  MyDeviceContentViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/22.
//

import UIKit
import JXSegmentedView
import RxSwift

class MyDeviceContentViewController: UIViewController {
    
    private let headCellID = "headCellID"
    private let contentCellID = "contentCellID"
    
    lazy var collectionView : UICollectionView = {
        //设置布局
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemSpac = CGFloat.widthSize()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: CGFloat.screenWidth, height: 105*CGFloat.widthSize())
        layout.minimumInteritemSpacing = itemSpac //item 间距
        layout.minimumLineSpacing = 18*CGFloat.widthSize()
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 10*CGFloat.widthSize())
        
        let collectView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = .clear
        collectView.showsVerticalScrollIndicator = false
        collectView.showsHorizontalScrollIndicator = false
        collectView.isScrollEnabled = true
        collectView.isUserInteractionEnabled = true
        
        collectView.register(MyDeviceHeaderCell.self, forCellWithReuseIdentifier: headCellID)
        collectView.register(MyDeviceContentCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectView
    }()
    
    var onPush:((Int) -> ())?
    
    var projectId = 0
    
    let viewModel = MyDeviceContentViewModel()
    let disposeBag = DisposeBag()
    
    init(projectId: Int){
        self.projectId = projectId
        viewModel.getDeviceList(projectId: projectId)
        viewModel.getProductMetrics(projectId: projectId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        subscribe(disposeBag, self.viewModel.deviceListDriver){[weak self] data in
            self?.collectionView.reloadData()
        }
        
        subscribe(disposeBag, self.viewModel.deviceMetricsDriver){[weak self] data in
            self?.collectionView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("reloadDeviceList"), object: nil)
    }
    
    @objc func reloadData(){
        viewModel.getDeviceList(projectId: projectId)
    }

}

extension MyDeviceContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            if self.viewModel.deviceListRelay.value.count > 0{
                return 1
            }else{
                return 0
            }
        }else{
            return self.viewModel.deviceListRelay.value.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize.init(width: CGFloat.screenWidth, height: 105*CGFloat.widthSize())
        }else{
            let width = (CGFloat.screenWidth - 60*CGFloat.widthSize())/2
            return CGSize.init(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets.init(top: 18*CGFloat.widthSize(), left: 20*CGFloat.widthSize(), bottom: 18*CGFloat.widthSize(), right: 20*CGFloat.widthSize())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headCellID, for: indexPath) as! MyDeviceHeaderCell
            if let data = self.viewModel.deviceMetricsRelay.value{
                cell.bind(data: data)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath) as! MyDeviceContentCell
            cell.bind(data: self.viewModel.deviceListRelay.value[indexPath.row])
            cell.onAlarm = {[weak self] in
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let data = self.viewModel.deviceListRelay.value[indexPath.row]
            self.onPush?(data.id)
        }
    }
    
}


extension MyDeviceContentViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
