//
//  PhoneAlertView.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/26.
//

import UIKit
import SwiftEntryKit
import RxSwift

class PhoneAlertView: UIView {
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let sureButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    var onSure:(() -> ())?
    
    lazy var entryAttributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.displayDuration = .infinity
        attributes.name = "PhoneAlertView"
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
        addSubview(sureButton)
        
        titleLabel.font = .textFont_16_bold
        titleLabel.textColor = .blackColor22
        titleLabel.textAlignment = .center
        titleLabel.text = "客服电话"
        
        contentLabel.font = .textFont_16_bold
        contentLabel.textColor = .blueColor48
        contentLabel.textAlignment = .center
        contentLabel.text = ""
        
        sureButton.setTitle("复制", for: .normal)
        sureButton.setTitleColor(.blueColor48, for: .normal)
        sureButton.titleLabel?.font = .textFont_14_medium
        sureButton.rx.tap.subscribe(onNext: { [weak self] in
            SwiftEntryKit.dismiss()
            self?.onSure?()
        }).disposed(by: disposeBag)
        
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.equalTo(22*CGFloat.widthSize())
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22*CGFloat.widthSize())
        }
        
        sureButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10*CGFloat.widthSize())
            $0.height.equalTo(32*CGFloat.widthSize())
            $0.width.equalTo(56*CGFloat.widthSize())
            $0.top.equalTo(contentLabel.snp.bottom).offset(20*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-10*CGFloat.widthSize())
        }
    }
    
    func show() {
        SwiftEntryKit.display(entry: self, using: entryAttributes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

