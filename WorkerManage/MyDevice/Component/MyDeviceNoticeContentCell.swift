//
//  MyDeviceNoticeContentCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/22.
//

import UIKit

class MyDeviceNoticeContentCell: UICollectionViewCell {
    let bgView = UIView()
    let contentIma = UIImageView()
    let leftIma = UIImageView()
    let descLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data:DeviceAlarmListData){
        if let url = URL(string: data.deviceCoverImage){
            self.contentIma.kf.setImage(with: url)
        }
        self.descLabel.text = "\(data.deviceLocation) | \(data.showName)"
        self.timeLabel.text = data.alarmTime
    }
    
    func initUI(){
        contentView.addSubview(bgView)
        bgView.addSubview(contentIma)
        bgView.addSubview(leftIma)
        bgView.addSubview(descLabel)
        bgView.addSubview(timeLabel)
        
        bgView.cornerRadius = 8*CGFloat.widthSize()
        bgView.backgroundColor = .whiteColor
        
        
        leftIma.image = UIImage(named: "mydevice_bug")
        
        timeLabel.textAlignment = .left
        timeLabel.textColor = .grayColor6D
        timeLabel.font = .textFont_10_medium
        timeLabel.text = ""
        
        descLabel.textAlignment = .left
        descLabel.textColor = .blackColor22
        descLabel.font = .textFont_12_medium
        descLabel.text = ""
        
        bgView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentIma.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-48*CGFloat.widthSize())
        }
        
        leftIma.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.top.equalTo(contentIma.snp.bottom).offset(2*CGFloat.widthSize())
            $0.width.height.equalTo(14*CGFloat.widthSize())
        }
        
        descLabel.snp.makeConstraints{
            $0.centerY.equalTo(leftIma)
            $0.leading.equalTo(leftIma.snp.trailing).offset(4*CGFloat.widthSize())
            $0.trailing.equalToSuperview().offset(-10*CGFloat.widthSize())
        }
        
        timeLabel.snp.makeConstraints{
            $0.top.equalTo(descLabel.snp.bottom).offset(4*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
        }
        
        
        
        
    }
}
