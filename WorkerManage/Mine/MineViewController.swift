//
//  MineViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MineViewControllor: CustomNavigationBarController {
    
    let name = UILabel()
    let rightArrow = UIImageView()
    let numLabel = UILabel()
    let headIma = UIImageView()
    let tableBg = UIView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    
    let bgIma = UIImageView()
    
    let loginOutBtn = UIButton()
    let disposeBag = DisposeBag()
    var data:UserInfoData?
    let viewModel = LoginViewModel()
    
    override init() {
        super.init()
        
        tabBarItem = UITabBarItem(title: "我的",
                                  image: CommonIconFont.iconfontToImage(iconText: IconFontName.minehead.rawValue, fontSize: 20, fontColor: .grayColor99).image?.withRenderingMode(.alwaysOriginal),
                                  selectedImage: CommonIconFont.iconfontToImage(iconText: IconFontName.mineRight.rawValue, fontSize: 20, fontColor: .blackColor48).image?.withRenderingMode(.alwaysOriginal))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.isHidden = true
        initGradient()
        setupViews()
        initData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("reloadUserInfo"), object: nil)
    }
    
    @objc func reloadData(){
        initData()
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
    
    @objc func gotoDetail(){
        if let data = data{
            let vc = PersonalBaseMessageViewController(data: data)
            self.navigationController?.pushViewController(vc)
        }
        
    }
    
    func setupViews() {
        name.textAlignment = .left
        name.font = .textFont_20_bold
        name.textColor = .blackColor
        name.text = "甄美丽"
        view.addSubview(name)
        
        rightArrow.image = CommonIconFont.iconfontToImage(iconText: IconFontName.right.rawValue, fontSize: 20, fontColor: .blackColor).image
        view.addSubview(rightArrow)
        
        let detailBtn = UIButton()
        view.addSubview(detailBtn)
        detailBtn.addTarget(self, action: #selector(gotoDetail), for: .touchUpInside)
        
        numLabel.textAlignment = .center
        numLabel.textColor = .grayColor5D
        numLabel.font = .textFont_14_medium
        numLabel.cornerRadius = 12*CGFloat.widthSize()
        numLabel.backgroundColor = .blueColorFF
        numLabel.text = "56个设备"
        view.addSubview(numLabel)
        
        headIma.cornerRadius = 36*CGFloat.widthSize()
        view.addSubview(headIma)
        
        tableBg.backgroundColor = .whiteColor
        tableBg.cornerRadius = 8*CGFloat.widthSize()
        view.addSubview(tableBg)
        
        tableBg.addSubview(tableView)
        tableView.registerCell(forClass: MineViewMainCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        name.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(80*CGFloat.widthSize())
            $0.height.equalTo(28*CGFloat.widthSize())
        }
        
        rightArrow.snp.makeConstraints{
            $0.leading.equalTo(name.snp.trailing).offset(4*CGFloat.widthSize())
            $0.centerY.equalTo(name)
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        detailBtn.snp.makeConstraints{
            $0.leading.equalTo(name)
            $0.centerY.equalTo(name)
            $0.height.equalTo(30*CGFloat.widthSize())
            $0.width.equalTo(100*CGFloat.widthSize())
        }
        
        numLabel.snp.makeConstraints{
            $0.width.equalTo(84*CGFloat.widthSize())
            $0.height.equalTo(24*CGFloat.widthSize())
            $0.top.equalTo(name.snp.bottom).offset(4*CGFloat.widthSize())
            $0.leading.equalTo(name)
        }
        
        headIma.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80*CGFloat.widthSize())
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.width.height.equalTo(72*CGFloat.widthSize())
        }
        
        tableBg.snp.makeConstraints{
            $0.top.equalTo(numLabel.snp.bottom).offset(56*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(100*CGFloat.widthSize())
        }
        
        tableView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(10*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    func initData(){
        if let dict = UserDefaults.standard.object(forKey: "userInfo") as? NSDictionary{
            if let data = UserInfoData(JSON: dict as! [String : Any]){
                self.name.text = data.name
                if data.avatar != ""{
                    let url = URL(string: data.avatar)
                    self.headIma.kf.setImage(with: url)
                }else{
                    self.headIma.image = UIImage(named: "mine_head")
                }
                self.numLabel.text = "\(data.totalDeviceCount)个设备"
                self.data = UserInfoData(id: data.id, account: data.account, name: data.name, avatar: data.avatar, sex: data.sex, totalDeviceCount: data.totalDeviceCount, region: data.region)
            }
        }
    }
}

extension MineViewControllor:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40*CGFloat.widthSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MineViewMainCell.self, for: indexPath)
        if indexPath.row == 0{
            cell.leftIma.image = CommonIconFont.iconfontToImage(iconText: IconFontName.aboutUs.rawValue, fontSize: 20, fontColor: .blueColor48).image
            cell.content.text = "关于劲拓家"
        }else{
            cell.leftIma.image = CommonIconFont.iconfontToImage(iconText: IconFontName.update.rawValue, fontSize: 20, fontColor: .greenColor83).image
            cell.content.text = "检查更新"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = AboutUsViewController()
            self.navigationController?.pushViewController(vc)
        }else{
            let vc = CheckUpdateViewController()
            self.navigationController?.pushViewController(vc)
        }
    }
}

