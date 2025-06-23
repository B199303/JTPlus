//
//  UnbindDeviceAlertView.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/13.
//


import UIKit
import SwiftEntryKit
import RxSwift

class UnbindDeviceAlertView: UIView {
    let titleLabel = UILabel()
    let cancelButton = UIButton()
    let sureButton = UIButton()
    let contentLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    var onTouch:(() -> ())?
    
    lazy var entryAttributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.displayDuration = .infinity
        attributes.name = "UnbindDeviceAlertView"
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
        addSubview(contentLabel)
        addSubview(cancelButton)
        addSubview(sureButton)
        
        titleLabel.font = .textFont_16_bold
        titleLabel.textColor = .blackColor22
        titleLabel.textAlignment = .center
        titleLabel.text = "解绑"
        
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
            self?.onTouch?()
            SwiftEntryKit.dismiss()
        }).disposed(by: disposeBag)
        
        contentLabel.font = .textFont_14_medium
        contentLabel.textColor = .blackColor22
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        contentLabel.text = "确认解绑该设备吗？解绑后将失去该设备的数据"
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.equalTo(22*CGFloat.widthSize())
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(14*CGFloat.widthSize())
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.top.equalTo(contentLabel.snp.bottom).offset(50*CGFloat.widthSize())
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
