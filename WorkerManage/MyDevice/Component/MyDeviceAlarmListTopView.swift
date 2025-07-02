//
//  MyDeviceAlarmListTopView.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/25.
//

import UIKit

class MyDeviceAlarmListTopView: UIView {
    let noDealBtn = UIButton()
    let dealBtn = UIButton()
    let line = UIView()
    
    var onTouch:((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touch(button:UIButton){
        if button == noDealBtn{
            noDealBtn.setTitleColor(.blackColor, for: .normal)
            dealBtn.setTitleColor(.grayColor9E, for: .normal)
        }else{
            noDealBtn.setTitleColor(.grayColor9E, for: .normal)
            dealBtn.setTitleColor(.blackColor, for: .normal)
        }
        self.onTouch?(button.tag)
    }
    
    func initUI(){
        self.backgroundColor = .whiteColor
        
        noDealBtn.setTitle("未处理", for: .normal)
        noDealBtn.setTitleColor(.blackColor, for: .normal)
        noDealBtn.titleLabel?.font = .textFont_14_medium
        noDealBtn.tag = 0
        noDealBtn.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        addSubview(noDealBtn)
        
        dealBtn.setTitle("已处理", for: .normal)
        dealBtn.setTitleColor(.grayColor9E, for: .normal)
        dealBtn.titleLabel?.font = .textFont_14_medium
        dealBtn.tag = 1
        dealBtn.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        addSubview(dealBtn)
        
        line.backgroundColor = .grayColorEE
        addSubview(line)
        
        noDealBtn.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(45*CGFloat.widthSize())
        }
        
        dealBtn.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(82*CGFloat.widthSize())
            $0.top.bottom.width.equalTo(noDealBtn)
        }
        
        line.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(CGFloat.widthSize())
        }
    }

}
