//
//  CheckKeyAlertView.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/6.
//


import UIKit
import SwiftEntryKit
import RxSwift

class CheckKeyAlertView: UIView {
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    let sureButton = UIButton()
    let inputBg = UIView()
    let inputTextField = UITextField()
    
    let disposeBag = DisposeBag()
    
    var onSure:(() -> ())?
    
    lazy var entryAttributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.displayDuration = .infinity
        attributes.name = "CheckKeyAlertView"
        attributes.positionConstraints.size = .init(width: .constant(value: 300*CGFloat.widthSize()), height: .intrinsic)
        attributes.roundCorners = .all(radius: 8*CGFloat.widthSize())
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.windowLevel = .normal
        attributes.screenBackground = .color(color: EKColor(.blackColor_25))
        attributes.entryBackground = .color(color: EKColor(.white))
        attributes.entranceAnimation = .none
        attributes.exitAnimation = .none
        return attributes
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(inputBg)
        inputBg.addSubview(inputTextField)
        addSubview(cancelButton)
        addSubview(sureButton)
        
        titleLabel.font = .textFont_16_bold
        titleLabel.textColor = .blackColor22
        titleLabel.textAlignment = .center
        titleLabel.text = "秘钥验证"
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.backgroundColor = .whiteColor
        cancelButton.setTitleColor(.grayColor66, for: .normal)
        cancelButton.titleLabel?.font = .textFont_14_medium
        cancelButton.rx.tap.subscribe(onNext: { _ in
            SwiftEntryKit.dismiss()
        }).disposed(by: disposeBag)
        
        sureButton.setTitle("确定", for: .normal)
        sureButton.setTitleColor(.blueColor48, for: .normal)
        sureButton.titleLabel?.font = .textFont_14_medium
        sureButton.rx.tap.subscribe(onNext: { [weak self] in
            SwiftEntryKit.dismiss()
            self?.onSure?()
        }).disposed(by: disposeBag)
        
        inputBg.backgroundColor = .grayColorF7
        inputBg.cornerRadius = 8*CGFloat.widthSize()
        
        inputTextField.placeholder = "请输入秘钥进行验证"
        inputTextField.setPlaceHolderTextColor(.grayColor99)
        inputTextField.textAlignment = .left
        inputTextField.textColor = .blackColor22
        inputTextField.font = .textFont_14_regular
        inputTextField.returnKeyType = .done
        inputTextField.delegate = self
        inputTextField.autocapitalizationType = .none
        inputTextField.autocorrectionType = .no
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.equalTo(22*CGFloat.widthSize())
        }
        
        inputBg.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10*CGFloat.widthSize())
            $0.top.equalTo(titleLabel.snp.bottom).offset(20*CGFloat.widthSize())
            $0.height.equalTo(40*CGFloat.widthSize())
        }
        
        inputTextField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(8*CGFloat.widthSize())
            $0.center.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.top.equalTo(inputBg.snp.bottom).offset(20*CGFloat.widthSize())
            $0.width.equalTo(56*CGFloat.widthSize())
            $0.height.equalTo(32*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-10*CGFloat.widthSize())
        }
        
        sureButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10*CGFloat.widthSize())
            $0.height.equalTo(32*CGFloat.widthSize())
            $0.width.equalTo(56*CGFloat.widthSize())
            $0.centerY.equalTo(cancelButton)
        }
    }
    
    func show() {
        SwiftEntryKit.display(entry: self, using: entryAttributes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckKeyAlertView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
