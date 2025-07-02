//
//  MyDeviceMainViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/4/25.
//

import UIKit
import JXSegmentedView
import AVFoundation
import RxSwift

class MyDeviceMainViewController: CustomNavigationBarController {
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    var dataSource = JXSegmentedTitleDataSource()
    
    let noDeviceView = UIView()
    let navView = UIView()
    
    let viewModel = MyDeviceListViewModel()
    let disposeBag = DisposeBag()
    var scanData:ScanResultData?
    var userId: Int = 0
    
    override init() {
        super.init()
        tabBarItem = UITabBarItem(title: "首页",
                                  image: CommonIconFont.iconfontToImage(iconText: IconFontName.homeRight.rawValue, fontSize: 20, fontColor: .grayColor99).image?.withRenderingMode(.alwaysOriginal),
                                  selectedImage: CommonIconFont.iconfontToImage(iconText: IconFontName.homeRight.rawValue, fontSize: 20, fontColor: .blackColor48).image?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if let dict = UserDefaults.standard.object(forKey: "userInfo") as? NSDictionary{
            if let data = UserInfoData(JSON: dict as! [String : Any]){
                viewModel.getProductList(userId: data.id)
                self.userId = data.id
            }
        }
        super.viewDidLoad()
        initGradient()
        initNavView()
        initNoDeviceView()
        initSegmentView()
        
        subscribe(disposeBag, self.viewModel.productListDriver){[weak self] data in
            guard let `self` = self else{return}
            if data.count > 0 {
                self.listContainerView.removeFromSuperview()
                self.initSegmentView()
                self.segmentedView.reloadData()
                
                self.segmentedView.isHidden = false
                self.listContainerView.isHidden = false
                self.noDeviceView.isHidden = true
            }else{
                self.segmentedView.isHidden = true
                self.listContainerView.isHidden = true
                self.noDeviceView.isHidden = false
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("reloadDeviceList"), object: nil)
        
        NotificationCenter.default.rx.notification(Notification.Name("scanResult")).subscribe(onNext: { [weak self] notification in
            guard let `self` = self else { return }
            if let urlStr = notification.userInfo?["urlstr"] as? String {
                if let url = URL(string: urlStr){
                    if let component = URLComponents(url: url, resolvingAgainstBaseURL: true){
                        if let queryItem = component.queryItems{
                            var dict:[String:Any] = [:]
                            for item in queryItem{
                                dict[item.name] = item.value
                            }
                            if let data = ScanResultData(JSON: dict ){
                                self.scanData = data
                                self.showAddAlert()
                            }
                        }
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        subscribe(disposeBag, self.viewModel.bindResultDriver){[weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        self.scanData = nil
                        self.viewModel.getProductList(userId: self.userId)
                    }
                }
            }
        }
        
        NotificationCenter.default.rx.notification(Notification.Name("notice")).subscribe(onNext: { [weak self] notification in
            if let list = notification.userInfo?["data"] as? [SocketMessageData] {
                if list.count > 1{
                    let vc = MyDeviceNoticeViewController()
                    UIViewController.getTopViewControllerInAlert()?.navigationController?.pushViewController(vc)
                }else if list.count == 1{
                    let item = list[0]
                    UIViewController.getTopViewControllerInAlert()?.navigationController?.pushViewController(MyDeviceDetailViewController(deviceId: item.deviceId))
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    @objc func reloadData(){
        self.viewModel.getProductList(userId: self.userId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(5*CGFloat.widthSize())
            $0.trailing.equalToSuperview().offset(-10*CGFloat.widthSize())
            $0.top.equalTo(navView.snp.bottom)
            $0.height.equalTo(40*CGFloat.widthSize())
        }
        listContainerView.snp.makeConstraints{
            $0.top.equalTo(segmentedView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    func initSegmentView(){
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titles = self.viewModel.productListRelay.value.map{$0.productName}
        dataSource.titleSelectedFont = .textFont_16_medium
        dataSource.titleNormalFont = .textFont_16_medium
        dataSource.titleNormalColor = .grayColor9E
        dataSource.titleSelectedColor = .blackColor
        self.segmentedDataSource = dataSource
        segmentedView.dataSource = segmentedDataSource
        segmentedView.defaultSelectedIndex = 0
        segmentedView.delegate = self
        segmentedView.backgroundColor = .clear
        
        view.addSubview(segmentedView)
        
        listContainerView.scrollView.isScrollEnabled = false
        segmentedView.listContainer = listContainerView
        
        view.addSubview(listContainerView)
    }
    
    func initGradient(){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        // 设置渐变的颜色
        gradientLayer.colors = [UIColor.blueColorBA.cgColor, UIColor.grayColorEF.cgColor]
        // 设置渐变的方向，从上到下
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        // 将渐变层添加到视图的layer上
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func initNoDeviceView(){
        noDeviceView.isHidden = true
        noDeviceView.backgroundColor = UIColor.whiteColor
        noDeviceView.cornerRadius = 12*CGFloat.widthSize()
        self.view.addSubview(noDeviceView)
        noDeviceView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(96*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(180*CGFloat.widthSize())
        }
        
        let placeIma = UIImageView()
        placeIma.image = UIImage(named: "first_place_nodata")
        noDeviceView.addSubview(placeIma)
        placeIma.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(102*CGFloat.widthSize())
            $0.height.equalTo(123*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(19*CGFloat.widthSize())
        }
        
        let addBtn = UIButton()
        addBtn.setTitle("添加设备", for: .normal)
        addBtn.setTitleColor(.whiteColor, for: .normal)
        addBtn.backgroundColor = .blueColor48
        addBtn.cornerRadius = 8*CGFloat.widthSize()
        addBtn.addTarget(self, action: #selector(touchAdd), for: .touchUpInside)
        noDeviceView.addSubview(addBtn)
        addBtn.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview().inset(24*CGFloat.widthSize())
            $0.height.equalTo(40*CGFloat.widthSize())
        }
    }
    
    @objc func touchAdd(){
        self.navigationController?.pushViewController(ScanViewController())
    }
    
    
    @objc func showAddAlert(){
        let alert = CheckKeyAlertView()
        alert.onSure = {[weak self] in
            guard let `self` = self else {return}
            if let item = self.scanData{
                self.viewModel.bindDevice(productIdentify: item.productIdentify, deviceIdentify: item.deviceIdentify, qrCodeKey: alert.inputTextField.text ?? "")
            }
        }
        alert.show()
    }
    
    func initNavView(){
        self.navBar.isHidden = true
        self.view.addSubview(navView)
        navView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(44*CGFloat.widthSize())
            $0.height.equalTo(44*CGFloat.widthSize())
        }
        
        let title = UILabel()
        title.textColor = UIColor.blackColor
        title.textAlignment = .left
        title.text = "我的设备"
        title.font = .textFont_16_bold
        navView.addSubview(title)
        title.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
        }
        
        let scanBtn = ExpandedTouchAreaButton()
        scanBtn.tag = 2
        let scanIma = CommonIconFont.iconfontToImage(iconText: IconFontName.scancode.rawValue, fontSize: 20, fontColor: .blackColor33)
        scanBtn.setImage(scanIma.image, for: .normal)
        scanBtn.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        navView.addSubview(scanBtn)
        
        let messageBtn = ExpandedTouchAreaButton()
        messageBtn.tag = 1
        let messageIma = CommonIconFont.iconfontToImage(iconText: IconFontName.message.rawValue, fontSize: 20, fontColor: .blackColor33)
        messageBtn.setImage(messageIma.image, for: .normal)
        messageBtn.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        navView.addSubview(messageBtn)
            
        scanBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20*CGFloat.widthSize())
        }
        
        messageBtn.snp.makeConstraints{
            $0.trailing.equalTo(scanBtn.snp.leading).offset(-16*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20*CGFloat.widthSize())
        }
        
    }
    
    @objc func touch(button:UIButton){
        if button.tag == 1{
            let vc = MyDeviceNoticeViewController()
            self.navigationController?.pushViewController(vc)
        }else if button.tag == 2{
            self.navigationController?.pushViewController(ScanViewController())
        }
        
    }
}

extension MyDeviceMainViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let title = self.dataSource.titles[index]
        let arr = self.viewModel.productListRelay.value.filter({$0.productName == title})
        let vc = MyDeviceContentViewController(projectId: arr[0].productId)
        vc.onPush = { [weak self] deviceId in
            self?.navigationController?.pushViewController(MyDeviceDetailViewController(deviceId: deviceId))
        }
        vc.onRecord = { [weak self] in
            guard let `self` = self else {return}
            let item = self.viewModel.productListRelay.value[index]
            self.navigationController?.pushViewController(MyDeviceProductRecordViewController(productId: item.productId))
        }
        return vc
    }
}

extension MyDeviceMainViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
            
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

