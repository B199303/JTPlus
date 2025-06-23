//
//  ChangePasswordViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/13.
//

import UIKit
import RxSwift

class ChangePasswordViewController: CustomNavigationBarController {
    let nowView = ChangePasswordInputView()
    let firstPassword = ChangePasswordInputView()
    let secPassword = ChangePasswordInputView()
    let sureButton = UIButton()
    
    let disposeBag = DisposeBag()
    let viewModel = ChangePasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
        subscribe(disposeBag, self.viewModel.buttonEnableDriver){ [weak self] enable in
            guard let `self` = self else {return}
            if enable{
                self.sureButton.backgroundColor = .blueColor48
                self.sureButton.isUserInteractionEnabled = true
            }else{
                self.sureButton.backgroundColor = .blueColor48_50
                self.sureButton.isUserInteractionEnabled = false
            }
        }
        
        subscribe(disposeBag, self.viewModel.updataResultDriver){[weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        self.loginOut()
                    }
                }
            }
        }
    }
    
    @objc func loginOut(){
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
        self.title = "修改密码"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        
        nowView.bind(name: "当前密码", place: "输入当前密码")
        nowView.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext:{[weak self] in
                guard let `self` = self else {return}
                self.viewModel.boolBtnEnable(now: nowView.inputTextField.text, first: firstPassword.inputTextField.text, sec: secPassword.inputTextField.text)
            })
            .disposed(by: disposeBag)
        view.addSubview(nowView)
        
        firstPassword.bind(name: "确认密码", place: "请设置新密码")
        firstPassword.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
                .subscribe(onNext:{[weak self] in
                    guard let `self` = self else {return}
                    self.viewModel.boolBtnEnable(now: nowView.inputTextField.text, first: firstPassword.inputTextField.text, sec: secPassword.inputTextField.text)
                })
                .disposed(by: disposeBag)
        view.addSubview(firstPassword)
        
        secPassword.bind(name: "确认密码", place: "请再次输入新密码")
        secPassword.inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext:{[weak self] in
                guard let `self` = self else {return}
                self.viewModel.boolBtnEnable(now: nowView.inputTextField.text, first: firstPassword.inputTextField.text, sec: secPassword.inputTextField.text)
            })
            .disposed(by: disposeBag)
        view.addSubview(secPassword)
        
        sureButton.backgroundColor = .blueColor48_50
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(.whiteColor, for: .normal)
        sureButton.titleLabel?.font = .textFont_16_bold
        sureButton.cornerRadius = 4*CGFloat.widthSize()
        sureButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.sureBtnTouch()
        }).disposed(by: disposeBag)
        view.addSubview(sureButton)
        
        nowView.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        firstPassword.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nowView.snp.bottom)
        }
        
        secPassword.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(firstPassword.snp.bottom)
        }
        
        sureButton.snp.makeConstraints{
            $0.top.equalTo(secPassword.snp.bottom).offset(42*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(48*CGFloat.widthSize())
        }
    }
    
    func sureBtnTouch(){
        if self.firstPassword.inputTextField.text != self.secPassword.inputTextField.text{
            self.view.makeToast("新密码必须一致", duration: 1.5, position: .center)
        }else{
            self.viewModel.getRsaKey(now: self.nowView.inputTextField.text ?? "", new: self.secPassword.inputTextField.text ?? "")
//            if self.viewModel.validatePassword(self.firstPassword.inputTextField.text ?? ""){
//                print("keyi")
////                self.viewModel.getRsaKey(now: self.nowView.inputTextField.text ?? "", new: self.secPassword.inputTextField.text ?? "")
//            }else{
//                self.view.makeToast("新密码不符合规范", duration: 1.5, position: .center)
//                print("buxing")
//            }
            
        }
        
    }
}
