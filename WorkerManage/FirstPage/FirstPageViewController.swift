//
//  FirstPageViewController.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/13.
//

import UIKit
import RxSwift
import JXBanner

class FirstPageViewController: CustomNavigationBarController {
    let navView = FirstPageNavView()
    let bottomView = UIView()
    let addBtn = UIButton()
    let deviceImaArr = ["device_hui", "device_bo"]
    let deviceTextArr = ["回流焊", "波峰焊"]
    lazy var banner: JXBanner = {
        let banner = JXBanner()
        banner.backgroundColor = UIColor.clear
        banner.delegate = self
        banner.dataSource = self
        return banner
    }()
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "首页",
                                  image: UIImage(named: "tabbar_home_nor")?.withRenderingMode(.alwaysOriginal),
                                  selectedImage: UIImage(named: "tabbar_home_sel")?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        self.navBar.isHidden = true
        self.view.backgroundColor = .blackColor16
        
        view.addSubview(navView)
        navView.leftIma.rx.tap.subscribe(onNext: { [weak self] in
            guard let `self` = self else {return}
            let vc = MessageRecordListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        navView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(132)
        }
        
        bottomView.addRoundedCorner(with: 30, at: [.topLeft, .topRight])
        bottomView.backgroundColor = .blackColor27
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(132)
        }
        
        addBtn.setImage(UIImage(named: "home_add"), for: .normal)
        addBtn.rx.tap.subscribe(onNext:{ [weak self] in
            guard let `self` = self else {return}
            self.view.makeToast("暂时不可添加")
            
        }).disposed(by: disposeBag)
        bottomView.addSubview(addBtn)
        addBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.width.equalTo(56)
            $0.height.equalTo(32)
        }
        
        bottomView.addSubview(banner)
        banner.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(62)
            $0.height.equalTo(500)
        }
    }
    
    func showWarn(){
        let alert = AlarmAlertView()
        self.view.addSubview(alert)
        alert.snp.makeConstraints{
            $0.width.equalTo(260)
            $0.center.equalToSuperview()
        }
    }
    
    func TRACE(_ message: String = "", fun: String = #function) {
            let names = fun.components(separatedBy: ":")
            var prettyName: String
            if names.count == 2 {
                prettyName = names[0]
            } else {
                prettyName = names[1]
            }

            if fun == "mqttDidDisconnect(_:withError:)" {
                prettyName = "didDisconect"
            }
            print("[TRACE] [\(prettyName)]: \(message)")
    }

}

extension FirstPageViewController: JXBannerDelegate, JXBannerDataSource{
    // 注册重用Cell标识
    func jxBanner(_ banner: JXBannerType)
    -> (JXBannerCellRegister) {
        return JXBannerCellRegister(type: DeviceScrollCell.self,
                                    reuseIdentifier: "DeviceScrollCell")
    }
    
    // 轮播总数
    func jxBanner(numberOfItems banner: JXBannerType)
    -> Int { return 2 }
    
    // 轮播cell内容设置
    func jxBanner(_ banner: JXBannerType,
                  cellForItemAt index: Int,
                  cell: UICollectionViewCell)
    -> UICollectionViewCell {
        let tempCell: DeviceScrollCell = cell as! DeviceScrollCell
        tempCell.deviceView.nameLabel.text = self.deviceTextArr[index]
        tempCell.deviceView.bgIma.image = UIImage(named: self.deviceImaArr[index])
        return tempCell
    }
    
    // banner基本设置（可选）
    func jxBanner(_ banner: JXBannerType,
                  layoutParams: JXBannerLayoutParams)
    -> JXBannerLayoutParams {
        return layoutParams
            .itemSize(CGSize(width: 295, height: 500))
            .itemSpacing(0)
    }
    
    func jxBanner(_ banner: JXBannerType,
                  params: JXBannerParams) -> JXBannerParams {
        return params
            .timeInterval(3)
            .isAutoPlay(false)
            .isShowPageControl(true)
            .isPagingEnabled(false)
            .cycleWay(.skipEnd)
            .contentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20))
    }
    
    public func jxBanner(_ banner: JXBannerType,
                         didSelectItemAt index: Int) {
        print(index)
    }
}
