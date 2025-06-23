//
//  SocketMessageAlertView.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/18.
//

import UIKit
import SwiftEntryKit
import RxSwift

class SocketMessageAlertView: UIView {
    let titleLabel = UILabel()
    let cancelLabel = UILabel()
    let sureLabel = UILabel()
    let cancelButton = UIButton()
    let sureButton = UIButton()
    let contentLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    var onTouch:((Int) -> ())?
    
    lazy var entryAttributes: EKAttributes = {
        var attributes = EKAttributes()
        attributes.position = .center
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.displayDuration = .infinity
        attributes.name = "SocketMessageAlertView"
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
        addSubview(cancelLabel)
        addSubview(sureLabel)
        addSubview(cancelButton)
        addSubview(sureButton)
        
        titleLabel.font = .textFont_16_bold
        titleLabel.textColor = .blackColor22
        titleLabel.textAlignment = .center
        titleLabel.text = "告警"
        
        cancelLabel.textAlignment = .left
        cancelLabel.text = "稍后处理"
        cancelLabel.textColor = .grayColor66
        cancelLabel.font = .textFont_14_medium
        
        sureLabel.textAlignment = .left
        sureLabel.text = "现在处理"
        sureLabel.textColor = .redColor40
        sureLabel.font = .textFont_14_medium
        
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            SwiftEntryKit.dismiss()
            self?.onTouch?(0)
        }).disposed(by: disposeBag)
        
        sureButton.rx.tap.subscribe(onNext: { [weak self] in
            SwiftEntryKit.dismiss()
            self?.onTouch?(1)
        }).disposed(by: disposeBag)
        
        contentLabel.font = .textFont_14_medium
        contentLabel.textColor = .blackColor22
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        contentLabel.text = "1号生产线-回流焊设备 SHEBEIBIANMA故障告警，请及时处理。"
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.equalTo(22*CGFloat.widthSize())
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(24*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-66*CGFloat.widthSize())
        }
        
        cancelLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(14*CGFloat.widthSize())
            $0.top.equalTo(contentLabel.snp.bottom).offset(30*CGFloat.widthSize())
        }
        
        sureLabel.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-14*CGFloat.widthSize())
            $0.top.equalTo(contentLabel.snp.bottom).offset(30*CGFloat.widthSize())
        }
        
        
        cancelButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(self.snp.centerX)
            $0.top.equalTo(contentLabel.snp.bottom).offset(20*CGFloat.widthSize())
        }
        
        sureButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(self.snp.centerX)
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
