//
//  AlarmAlertView.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/26.
//

import UIKit
import RxSwift

class AlarmAlertView: UIView {
    let bgView = UIView()
    let bgIma = UIImageView()
    let title = UILabel()
    let modelNumber = UILabel()
    let idLabel = UILabel()
    let contentLabel = UILabel()
    let timeLabel = UILabel()
    let sureBtn = UIButton()
    
    let disposeBag = DisposeBag()
    var warn:mqttWarn?
    
    init(){
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data:mqttWarn){
        modelNumber.text = "设备型号：\(data.deviceModel)"
        idLabel.text = "设备ID：\(data.deviceNumber)"
        if let content = data.data{
            contentLabel.text = "告警内容：\(content.msg)"
            timeLabel.text = "告警时间：\(content.alarmTime)"
        }
        self.warn = data
    }
    
    func initUI(){
        addSubview(bgView)
        bgView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        bgIma.image = UIImage(named: "home_warn_bg")
        bgView.addSubview(bgIma)
        bgIma.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        title.font = .textFont_14_bold
        title.textColor = .grayColorD1
        title.textAlignment = .center
        title.text = "警告"
        bgView.addSubview(title)
        title.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        modelNumber.font = .textFont_12_regular
        modelNumber.textColor = .grayColorC4
        modelNumber.textAlignment = .left
        modelNumber.text = "设备型号：波峰焊01型号"
        bgView.addSubview(modelNumber)
        modelNumber.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.height.equalTo(17)
        }
        
        idLabel.font = .textFont_12_regular
        idLabel.textColor = .grayColorC4
        idLabel.textAlignment = .left
        idLabel.text = "设备ID：673214687"
        bgView.addSubview(idLabel)
        idLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalTo(modelNumber.snp.bottom).offset(6)
            $0.height.equalTo(17)
        }
        
        contentLabel.text = "告警内容：通讯失败"
        contentLabel.font = .textFont_12_regular
        contentLabel.textColor = .grayColorC4
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(38)
            $0.top.equalTo(idLabel.snp.bottom).offset(6)
        }
        
        timeLabel.text = "告警时间：2023/07/06 14:16:19"
        timeLabel.font = .textFont_12_regular
        timeLabel.textColor = .grayColorC4
        timeLabel.textAlignment = .left
        bgView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(38)
            $0.top.equalTo(contentLabel.snp.bottom).offset(6)
            $0.height.equalTo(17)
        }
        
        sureBtn.borderWidth = 1
        sureBtn.borderColor = .grayColorBA
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.grayColorD1, for: .normal)
        sureBtn.titleLabel?.font = .textFont_12_bold
        bgView.addSubview(sureBtn)
        sureBtn.rx.tap.subscribe(onNext:{[weak self] in
            guard let `self` = self else {return}
            self.removeFromSuperview()
        }).disposed(by: disposeBag)
        sureBtn.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timeLabel.snp.bottom).offset(12)
            $0.width.equalTo(64)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }

}
