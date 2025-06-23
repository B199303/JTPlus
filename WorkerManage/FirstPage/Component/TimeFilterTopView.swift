//
//  TimeFilterTopView.swift
//  WorkerManage
//
//  Created by BL L on 2022/10/18.
//

import UIKit

class TimeFilterTopView: UIView {
    let leftBg = UIButton()
    let leftDate = UITextField()
    let midLine = UIView()
    let rightBg = UIButton()
    let rightDate = UITextField()
    let bottomLine = UIView()

    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    func initUI(){
        self.backgroundColor = .bgGrayColor
        
        midLine.backgroundColor = .blackColor
        addSubview(midLine)
        
        leftBg.backgroundColor = .whiteColor
        leftBg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.49).cgColor
        leftBg.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        leftBg.layer.shadowRadius = 1
        leftBg.layer.shadowOpacity = 1
        leftBg.layer.masksToBounds = false
        leftBg.layer.cornerRadius = 6
        addSubview(leftBg)
        
        leftDate.textAlignment = .left
        leftDate.textColor = .grayColor80
        leftDate.font = .textFont_15_regular
        leftDate.placeholder = "选择初始时间"
        leftDate.setPlaceHolderTextColor(.grayColor80)
        leftDate.isUserInteractionEnabled = false
        leftBg.addSubview(leftDate)
        
        rightBg.backgroundColor = .whiteColor
        rightBg.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.49).cgColor
        rightBg.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        rightBg.layer.shadowRadius = 1
        rightBg.layer.shadowOpacity = 1
        rightBg.layer.masksToBounds = false
        rightBg.layer.cornerRadius = 6
        addSubview(rightBg)
        
        rightDate.textAlignment = .left
        rightDate.textColor = .grayColor80
        rightDate.font = .textFont_15_regular
        rightDate.placeholder = "选择结束时间"
        rightDate.setPlaceHolderTextColor(.grayColor80)
        rightDate.isUserInteractionEnabled = false
        rightBg.addSubview(rightDate)
        
        bottomLine.backgroundColor = .bgGrayColor
        addSubview(bottomLine)
        
        midLine.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalTo(8)
            $0.height.equalTo(1.5)
        }
        
        leftBg.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(27)
            $0.trailing.equalTo(midLine.snp.leading).offset(-6.5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        leftDate.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(11)
            $0.centerY.equalToSuperview()
        }
        
        rightBg.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-27)
            $0.leading.equalTo(midLine.snp.trailing).offset(6.5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        rightDate.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(11)
            $0.centerY.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
