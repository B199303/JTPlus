//
//  FirstPageNavView.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/20.
//

import UIKit

class FirstPageNavView: UIView {
    let leftIma = UIButton()
    let rightBg = UIImageView()
    let rightLabel = UILabel()

    init(){
        super.init(frame: .zero)
        self.backgroundColor = .clear
        initUI()
    }
    
    func bind(warn:mqttWarn){
        if let data = warn.data{
            self.rightLabel.text = "警告！警告！\(warn.deviceModel)，设备\(warn.deviceNumber)\(data.msg)！"
        }
    }
    
    func initUI(){
        leftIma.setImage(UIImage(named: "home_titleIma"), for: .normal)
        addSubview(leftIma)
        
        rightBg.image = UIImage(named: "home_title_bg")
        addSubview(rightBg)
        
        rightLabel.font = .textFont_13_bold
        rightLabel.textColor = .whiteColor
        rightLabel.textAlignment = .left
        rightLabel.text = "所有设备正常运行，无须担心。"
        rightBg.addSubview(rightLabel)
        
        leftIma.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(48)
            $0.width.equalTo(52)
            $0.height.equalTo(62)
        }
        
        rightBg.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(89)
            $0.centerY.equalTo(leftIma)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(64)
        }
        
        rightLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(5)
            $0.top.equalToSuperview().offset(11)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
