//
//  FindProductAlertView.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/6.
//

import UIKit
import SwiftEntryKit
import RxSwift

class FindProductAlertView: UIView {
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    let sureButton = UIButton()
    let findLabel = UILabel()
    let proLabel = UILabel()
    let addLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    var onTouch:(() -> ())?
    
    lazy var entryAttributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.displayDuration = .infinity
        attributes.name = "FindProductAlertView"
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
        addSubview(findLabel)
        addSubview(proLabel)
        addSubview(addLabel)
        addSubview(cancelButton)
        addSubview(sureButton)
        
        titleLabel.font = .textFont_16_bold
        titleLabel.textColor = .blackColor22
        titleLabel.textAlignment = .center
        titleLabel.text = "秘钥验证"
        
        cancelButton.setTitle("否", for: .normal)
        cancelButton.backgroundColor = .whiteColor
        cancelButton.setTitleColor(.grayColor66, for: .normal)
        cancelButton.titleLabel?.font = .textFont_14_medium
        cancelButton.rx.tap.subscribe(onNext: { _ in
            SwiftEntryKit.dismiss()
        }).disposed(by: disposeBag)
        
        sureButton.setTitle("是", for: .normal)
        sureButton.setTitleColor(.blueColor48, for: .normal)
        sureButton.titleLabel?.font = .textFont_14_medium
        sureButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.onTouch?()
            SwiftEntryKit.dismiss()
        }).disposed(by: disposeBag)
        
        findLabel.font = .textFont_14_medium
        findLabel.textColor = .blackColor22
        findLabel.textAlignment = .left
        findLabel.text = "首次发现"
       
        proLabel.font = .textFont_14_medium
        proLabel.textColor = .blueColor48
        proLabel.textAlignment = .left
        proLabel.text = "产品类型"
        
        addLabel.font = .textFont_14_medium
        addLabel.textColor = .blackColor22
        addLabel.textAlignment = .left
        addLabel.text = "是否将该设备添加至您的APP中？"
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.equalTo(22*CGFloat.widthSize())
        }
        
        findLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(24*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        proLabel.snp.makeConstraints{
            $0.centerY.equalTo(findLabel)
            $0.leading.equalTo(findLabel.snp.trailing).offset(4*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        addLabel.snp.makeConstraints{
            $0.top.equalTo(findLabel.snp.bottom).offset(4*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(24*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.top.equalTo(addLabel.snp.bottom).offset(20*CGFloat.widthSize())
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
