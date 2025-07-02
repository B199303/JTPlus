//
//  MyDeviceContentCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/20.
//

import UIKit

class MyDeviceContentCell: UICollectionViewCell {
    let bgView = UIView()
    let contentIma = UIImageView()
    let numLabel = UILabel()
    let wifiIma = UIImageView()
    let descLabel = UILabel()
    let statusLabel = UILabel()
    let alarmBtn = ExpandedTouchAreaButton()
    let alarmIma = UIImageView()
    
    let cellWidth:CGFloat = (CGFloat.screenWidth - 40*CGFloat.widthSize())/2
    
    var onAlarm:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data:DeviceListData){
        if data.deviceCoverImage != ""{
            let url = URL(string: data.deviceCoverImage)
            self.contentIma.kf.setImage(with: url)
        }
        self.numLabel.text = data.showName
        let statusText = data.status == 1 ? "｜正常" : "｜告警"
        self.statusLabel.text = statusText
        alarmBtn.isHidden = data.status == 1
        self.descLabel.text = "\(data.showLocation) "
        
        if data.online{
            wifiIma.image = UIImage(named: "mydevice_wifi")
        }else{
            wifiIma.image = UIImage(named: "mydevice_wifi_no")
        }
    }
    
    @objc func touchAlarm(){
        self.onAlarm?()
    }
    
    func initUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(contentIma)
        bgView.addSubview(numLabel)
        bgView.addSubview(wifiIma)
        bgView.addSubview(descLabel)
        bgView.addSubview(statusLabel)
        bgView.addSubview(alarmBtn)
        alarmBtn.addSubview(alarmIma)
        
        bgView.cornerRadius = 8*CGFloat.widthSize()
        bgView.backgroundColor = .whiteColor
        
        numLabel.textAlignment = .left
        numLabel.textColor = .blackColor22
        numLabel.font = .textFont_12_medium
        numLabel.text = "机身编号"
        
        descLabel.textAlignment = .left
        descLabel.textColor = .grayColor6D
        descLabel.font = .textFont_10_medium
        descLabel.text = "1号产线 | 正常 工作4h32m"
        
        statusLabel.text = "正常"
        statusLabel.textAlignment = .left
        statusLabel.textColor = .grayColor6D
        statusLabel.font = .textFont_10_medium
        
        alarmBtn.backgroundColor = .redColor40
        alarmBtn.cornerRadius = 8*CGFloat.widthSize()
        alarmBtn.addTarget(self, action: #selector(touchAlarm), for: .touchUpInside)
        
        alarmIma.image = CommonIconFont.iconfontToImage(iconText: IconFontName.tip.rawValue, fontSize: 20, fontColor: .whiteColor).image
        
        bgView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentIma.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-48*CGFloat.widthSize())
        }
        
        numLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().offset(-33*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.width.lessThanOrEqualTo(cellWidth - 20*CGFloat.widthSize() - 28*CGFloat.widthSize())
        }
        
        wifiIma.snp.makeConstraints{
            $0.leading.equalTo(numLabel.snp.trailing).offset(4*CGFloat.widthSize())
            $0.centerY.equalTo(numLabel)
            $0.width.height.equalTo(14*CGFloat.widthSize())
        }
        
        descLabel.snp.makeConstraints{
            $0.top.equalTo(numLabel.snp.bottom).offset(4*CGFloat.widthSize())
            $0.leading.equalTo(numLabel)
            $0.width.lessThanOrEqualTo(cellWidth - 20*CGFloat.widthSize() - 38*CGFloat.widthSize())
        }
        
        statusLabel.snp.makeConstraints{
            $0.leading.equalTo(descLabel.snp.trailing)
            $0.centerY.equalTo(descLabel)
            $0.width.equalTo(40*CGFloat.widthSize())
        }
        
        alarmBtn.snp.makeConstraints{
            $0.trailing.top.equalToSuperview()
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        alarmIma.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.height.width.equalTo(14*CGFloat.widthSize())
        }
    }
}
