//
//  PersonalBaseMessageViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/13.
//

import UIKit
import RxSwift

class PersonalBaseMessageViewController: CustomNavigationBarController {
    let tableView = UITableView(frame: .zero, style: .plain)
    let cell = PersonalBaseMessageCell()
    let sexSelectView = MineSexSelectView()
    
    let loginOutBtn = UIButton()
    var data:UserInfoData?
    let viewModel = ChangePasswordViewModel()
    let disposeBag = DisposeBag()
    var sex = 0
    
    init(data:UserInfoData? = nil) {
        super.init()
        if let data = data{
            self.data = data
            self.cell.bind(data: data)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
        subscribe(disposeBag, self.viewModel.updataResultDriver){ [weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        if let data = self.data{
                            data.sex = self.sex
                            let dataDic:[String:Any] = data.toJSON()
                            UserDefaults.standard.setValue(dataDic, forKey: "userInfo")
                        }
                        NotificationCenter.default.post(name: Notification.Name("reloadUserInfo"),
                                                        object: nil,
                                                        userInfo: nil)
                    }
                }
            }
        }
        
        subscribe(disposeBag, self.viewModel.logOutDriver){[weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        self.dealLogOutData()
                    }
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("reloadUserInfo"), object: nil)
    }
    
    @objc func reloadData(){
        if let dict = UserDefaults.standard.object(forKey: "userInfo") as? NSDictionary{
            if let data = UserInfoData(JSON: dict as! [String : Any]){
                self.data = data
                self.cell.bind(data: data)
            }
        }
    }
    
    @objc func loginOut(){
        self.sexSelectView.isHidden = true
        self.viewModel.logOut()
    }
    
    func dealLogOutData(){
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "pass")
        UserDefaults.standard.removeObject(forKey: "userInfo")
        
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                window = keyWindow
            }
        }else{
            window = UIApplication.shared.keyWindow!
        }
        debugPrint("keyWindow.set(newRootController: LaunchRouter.module())")
        
        guard let window = window else {return}
        
        window.set(newRootController: LoginViewController())
    }
    
    func initUI(){
        self.title = "基本信息"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom).offset(2*CGFloat.widthSize())
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loginOutBtn.borderColor = .grayColorEE
        loginOutBtn.borderWidth = 1
        loginOutBtn.backgroundColor = .whiteColor
        loginOutBtn.setTitle("退出登录", for: .normal)
        loginOutBtn.setTitleColor(.blackColor33, for: .normal)
        loginOutBtn.titleLabel?.font = .textFont_16_bold
        loginOutBtn.cornerRadius = 4*CGFloat.widthSize()
        loginOutBtn.addTarget(self, action: #selector(loginOut), for: .touchUpInside)
        view.addSubview(loginOutBtn)
        
        loginOutBtn.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-100*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(48*CGFloat.widthSize())
        }
        
        cell.onTouch = {[weak self] index in
            guard let `self` = self else {return}
            self.sexSelectView.isHidden = true
            if index == 1{
                let vc = ChangePasswordViewController()
                self.navigationController?.pushViewController(vc)
            }else if index == 2{
                let vc = SubmitHeadViewViewController()
                vc.data = self.data
                self.navigationController?.pushViewController(vc)
            }else if index == 3{
                let vc = ChangeNickNameViewController()
                vc.data = self.data
                self.navigationController?.pushViewController(vc)
            }else if index == 4{
                self.sexSelectView.isHidden = !self.sexSelectView.isHidden
            }else{
                
            }
        }
        
        sexSelectView.backgroundColor = .whiteColor
        sexSelectView.layer.shadowColor = UIColor(red: 0.28, green: 0.57, blue: 1, alpha: 0.1).cgColor
        sexSelectView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        sexSelectView.layer.shadowRadius = 8*CGFloat.widthSize()
        sexSelectView.layer.shadowOpacity = 1
        sexSelectView.layer.masksToBounds = false
        sexSelectView.layer.cornerRadius = 8*CGFloat.widthSize()
        sexSelectView.isHidden = true
        sexSelectView.onTouch = {[weak self] sex in
            guard let `self` = self else {return}
            self.sex = sex
            self.sexSelectView.isHidden = true
            if sex == 1{
                self.cell.genderView.bind(left: "性别", right: "男")
            }else{
                self.cell.genderView.bind(left: "性别", right: "女")
            }
            self.viewModel.change(sex: sex)
        }
        view.addSubview(sexSelectView)
        sexSelectView.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-30*CGFloat.widthSize())
            $0.top.equalTo(navBar.snp.bottom).offset(288*CGFloat.widthSize())
            $0.width.equalTo(140*CGFloat.widthSize())
        }
    }
}

extension PersonalBaseMessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
}
