//
//  ChangeNickNameViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/15.
//

import UIKit
import RxSwift

class ChangeNickNameViewController: CustomNavigationBarController {
    
    let nameLabel = UILabel()
    let inputBg = UIView()
    let inputTextField = UITextField()
    let saveButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    let viewModel = ChangePasswordViewModel()
    var data: UserInfoData?

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        
        subscribe(disposeBag, self.viewModel.buttonEnableDriver){ [weak self] able in
            guard let `self` = self else {return}
            if able{
                self.saveButton.backgroundColor = .blueColor48
                self.saveButton.isUserInteractionEnabled = true
            }else{
                self.saveButton.backgroundColor = .blueColor48_50
                self.saveButton.isUserInteractionEnabled = false
            }
        }
        
        subscribe(disposeBag, self.viewModel.updataResultDriver){ [weak self] result in
            if let result = result{
                self?.view.makeToast(result.msg, duration: 1.5, position: .center)
                if result.code == 20000{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) { [weak self] in
                        guard let `self` = self else {return}
                        if let data = self.data{
                            data.name = self.inputTextField.text ?? ""
                            let dataDic:[String:Any] = data.toJSON()
                            UserDefaults.standard.setValue(dataDic, forKey: "userInfo")
                        }
                        NotificationCenter.default.post(name: Notification.Name("reloadUserInfo"),
                                                        object: nil,
                                                        userInfo: nil)
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }
        }
    }
    

    func initUI(){
        self.title = "昵称"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF
        
        nameLabel.textAlignment = .left
        nameLabel.font = .textFont_14_medium
        nameLabel.textColor = .blackColor
        nameLabel.text = "昵称"
        view.addSubview(nameLabel)
        
        inputBg.backgroundColor = .grayColorF6
        inputBg.cornerRadius = 8*CGFloat.widthSize()
        view.addSubview(inputBg)
        
        inputTextField.placeholder = "请输入昵称"
        inputTextField.setPlaceHolderTextColor(.grayColor99)
        inputTextField.textAlignment = .left
        inputTextField.textColor = .blackColor22
        inputTextField.font = .textFont_14_regular
        inputTextField.returnKeyType = .done
        inputTextField.delegate = self
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        inputTextField.text = self.data?.name ?? ""
        inputBg.addSubview(inputTextField)
        inputTextField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe(onNext:{[weak self] in
                guard let `self` = self else {return}
                self.viewModel.boolSaveBtnEnable(name: inputTextField.text)
            })
            .disposed(by: disposeBag)
        
        saveButton.backgroundColor = .blueColor48
        saveButton.setTitle("保存", for: .normal)
        saveButton.setTitleColor(.whiteColor, for: .normal)
        saveButton.titleLabel?.font = .textFont_16_bold
        saveButton.cornerRadius = 4*CGFloat.widthSize()
        saveButton.isUserInteractionEnabled = true
        self.viewModel.buttonEnableRelay.accept(true)
        saveButton.rx.tap.subscribe(onNext:{ [weak self] in
            self?.saveBtnTouch()
        }).disposed(by: disposeBag)
        view.addSubview(saveButton)
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(navBar.snp.bottom).offset(20*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        inputBg.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.top.equalTo(nameLabel.snp.bottom).offset(10*CGFloat.widthSize())
            $0.height.equalTo(42*CGFloat.widthSize())
        }
        
        inputTextField.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.height.equalTo(20*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(12*CGFloat.widthSize())
        }
        
        saveButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.top.equalTo(inputBg.snp.bottom).offset(64*CGFloat.widthSize())
            $0.height.equalTo(48*CGFloat.widthSize())
        }
    }
    
    func saveBtnTouch(){
        self.viewModel.change(name: self.inputTextField.text ?? "")
    }

}

extension ChangeNickNameViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
