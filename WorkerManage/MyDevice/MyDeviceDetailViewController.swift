//
//  MyDeviceDetailViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/23.
//

import UIKit
import RxSwift

class MyDeviceDetailViewController: CustomNavigationBarController {
    
    let backButton = ExpandedTouchAreaButton()
    let manageButton = ExpandedTouchAreaButton()
    let titleLabel = UILabel()
    let tableView = UITableView(frame: .zero, style: .plain)
    let headCell = MyDeviceDetailHeaderCell()
    let numCell = MyDeviceDetailNumCell()
    let progressCell = MyDeviceDetailProgressCell()
    let barCell = MyDeviceDetailBarCell()
    
    let slideView = MyDeviceDetailShowView()
    
    var isShow = false
    let viewModel = MyDeviceDetailViewModel()
    let disposeBag = DisposeBag()
    var deviceId = 0
    
    init(deviceId:Int){
        super.init()
        self.deviceId = deviceId
        viewModel.getDeviceDetailData(deviceId: deviceId)
        viewModel.getDeviceMetrics(deviceId: deviceId)
        viewModel.getDeviceAlarmStatic(deviceId: deviceId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGradient()
        initUI()
        
        subscribe(disposeBag, viewModel.deviceDetailDriver){[weak self] data in
            if let data = data{
                self?.titleLabel.text = data.deviceEncoding
                self?.slideView.bind(detail: data)
                self?.headCell.bind(detail: data)
                self?.tableView.reloadData()
            }
        }
        
        subscribe(disposeBag, viewModel.deviceMetricsDriver){[weak self] data in
            if let data = data{
                self?.numCell.bind(data: data)
                self?.progressCell.bind(data: data)
            }
        }
        
        subscribe(disposeBag, viewModel.deviceAlarmStaticDriver){[weak self] data in
            self?.barCell.bind(data: data)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("reloadDeviceDetail"), object: nil)
    }
    
    @objc func reloadData(){
        self.viewModel.getDeviceDetailData(deviceId: deviceId)
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
    
    @objc func back(){
        self.navigationController?.popViewController()
    }
    
    @objc func gotoManage(){
        self.isShow = false
        self.slideView.bind(show: self.isShow)
        slideView.snp.remakeConstraints{
            $0.trailing.equalToSuperview().offset(196*CGFloat.widthSize())
            $0.width.equalTo(236*CGFloat.widthSize())
            $0.height.equalTo(120*CGFloat.widthSize())
            $0.top.equalTo(self.tableView)
        }
        
        let vc = MyDeviceManageViewController()
        vc.detailData = self.viewModel.deviceDetailRelay.value
        self.navigationController?.pushViewController(vc)
    }
    
    func initUI(){
        self.navBar.isHidden = true
        
        backButton.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.left.rawValue, fontSize: 20, fontColor: .blackColor33).image, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(12*CGFloat.widthSize())
            $0.centerY.equalTo(self.navBar.titleView)
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        manageButton.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.manage.rawValue, fontSize: 20, fontColor: .blackColor33).image, for: .normal)
        manageButton.addTarget(self, action: #selector(gotoManage), for: .touchUpInside)
        view.addSubview(manageButton)
        manageButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-12*CGFloat.widthSize())
            $0.centerY.equalTo(self.navBar.titleView)
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        titleLabel.textColor = .blackColor
        titleLabel.textAlignment = .center
        titleLabel.font = .textFont_16_bold
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(navBar.titleView)
        }
        
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        numCell.onTouch = { [weak self] in
            guard let `self` = self else {return}
            self.navigationController?.pushViewController(MyDeviceProductRecordViewController(deviceId: self.deviceId))
        }
        
        headCell.onTouch = { [weak self] in
            guard let `self` = self, let data = self.viewModel.deviceDetailRelay.value else {return}
            let vc = MyDeviceAlarmListViewController(deviceId: self.deviceId)
            vc.title = data.showName
            self.navigationController?.pushViewController(vc)
        }
        
        view.addSubview(slideView)
        slideView.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(196*CGFloat.widthSize())
            $0.width.equalTo(236*CGFloat.widthSize())
            $0.height.equalTo(120*CGFloat.widthSize())
            $0.top.equalTo(tableView)
        }
        slideView.onTouch = {
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                // 移动按钮到视图的左侧之外
                guard let `self` = self else {return}
                if !self.isShow{
                    slideView.snp.remakeConstraints{
                        $0.trailing.equalToSuperview()
                        $0.width.equalTo(236*CGFloat.widthSize())
                        $0.height.equalTo(120*CGFloat.widthSize())
                        $0.top.equalTo(self.tableView)
                    }
                }else{
                    slideView.snp.remakeConstraints{
                        $0.trailing.equalToSuperview().offset(196*CGFloat.widthSize())
                        $0.width.equalTo(236*CGFloat.widthSize())
                        $0.height.equalTo(120*CGFloat.widthSize())
                        $0.top.equalTo(self.tableView)
                    }
                }
                self.isShow = !self.isShow
                self.slideView.bind(show: self.isShow)
                
            }) { (finished) in
                // 动画完成后的回调，例如可以重新设置按钮的位置或者做其他操作
                print("动画完成")
            }
        }
    }
    
    
    

}

extension MyDeviceDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            return headCell
        }else if indexPath.row == 1{
            return numCell
        }else if indexPath.row == 2{
            return progressCell
        }else{
            return barCell
        }
        
    }
}
