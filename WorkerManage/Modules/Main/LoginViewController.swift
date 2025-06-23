//
//  LoginViewController.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation
import UIKit
import RxSwift
import Toast_Swift
import RxCocoa
import SwiftMessages
import JGProgressHUD

class LoginViewController: KeyboardManagerViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView(frame: .zero, style: .plain)
    let loginCell = LoginCell()
    let hud = JGProgressHUD()
    
    let viewModel = LoginViewModel()
    
    init(){
        super.init(scrollView: self.tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribe(disposeBag, self.viewModel.isLoginDriver){ [weak self] b in
            if b {
                if UserDefaults.standard.string(forKey: "token") != nil {
                    self?.hud.dismiss(animated: true)
                    self?.exchangeTabar()
//                    XGPush.defaultManager().xgApplicationBadgeNumber = 0
                }
            }
        }
        
        subscribe(disposeBag, self.viewModel.msgDriver){[weak self] msg in
            self?.hud.dismiss(animated: true)
            if msg != ""{
                self?.view.makeToast(msg, duration: 1.5, position: .center)
            }
        }
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupViews() {
        self.navBar.isHidden = true
        view.backgroundColor = .whiteColor
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        loginCell.loginButton.rx.tap.subscribe(onNext:{[weak self] in
            self?.signIn()
        }).disposed(by: disposeBag)
        
        
    }
    
    func signIn(){
        if self.loginCell.nameView.inputText.text == "" || self.loginCell.passView.inputText.text == "" {
            var style = ToastManager.shared.style
            style.backgroundColor = .deepBlue
            self.view.makeToast("有未输入项", duration: 2.0, position: ToastManager.shared.position, title: nil, image: nil, style: style, completion: nil)
            //            self.view.toa
            return
        }
        self.hud.textLabel.text = "登录中"
        self.hud.show(in: self.view)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) { [weak self] in
            guard let `self` = self else { return }
            self.hud.dismiss(animated: true)
        }
        
        self.viewModel.getRsaKey(account: self.loginCell.nameView.inputText.text ?? "", password: self.loginCell.passView.inputText.text ?? "")
//        self.exchangeTabar()
        
    }
    
    func exchangeTabar(){
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
        window.set(newRootController: LaunchRouter.module())
    }
}


extension LoginViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat.screenHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return loginCell
    }
}


//TODO: move to another place
func subscribe<T>(_ disposeBag: DisposeBag, _ driver: Driver<T>, _ onNext: ((T) -> Void)? = nil) {
    driver.drive(onNext: onNext).disposed(by: disposeBag)
}

func subscribe<T>(_ disposeBag: DisposeBag, _ signal: Signal<T>, _ onNext: ((T) -> Void)? = nil) {
    signal.emit(onNext: onNext).disposed(by: disposeBag)
}

func subscribe<T>(_ disposeBag: DisposeBag, _ observable: Observable<T>, _ onNext: ((T) -> Void)? = nil) {
    observable
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .subscribe(onNext: onNext)
        .disposed(by: disposeBag)
}

func subscribe<T>(_ scheduler: ImmediateSchedulerType, _ disposeBag: DisposeBag, _ observable: Observable<T>, _ onNext: ((T) -> Void)? = nil) {
    observable
        .observe(on: scheduler)
        .subscribe(onNext: onNext)
        .disposed(by: disposeBag)
}
