//
//  MyDeviceDetailHeaderCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/23.
//

import UIKit

class MyDeviceDetailHeaderCell: UITableViewCell {
    let bigPic = UIImageView()
    let warnBg = UIView()
    let leftIma = UIImageView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.initUI()
    }
    
    func bind(detail:DeviceDetailData){
        if detail.recentlyAlarmInfo == nil{
            self.warnBg.isHidden = true
            bigPic.snp.remakeConstraints{
                $0.leading.trailing.top.equalToSuperview()
                $0.height.equalTo(152*CGFloat.widthSize())
                $0.bottom.equalToSuperview()
            }
        }else{
            self.warnBg.isHidden = false
            self.timeLabel.text = detail.recentlyAlarmInfo?.alarmTime
            self.descLabel.text = detail.recentlyAlarmInfo?.alarmContent
            bigPic.snp.remakeConstraints{
                $0.leading.trailing.top.equalToSuperview()
                $0.height.equalTo(152*CGFloat.widthSize())
                $0.bottom.equalToSuperview().offset(-92*CGFloat.widthSize())
            }
        }
        if detail.deviceCoverImage != ""{
            let url = URL(string: detail.deviceCoverImage)
            self.bigPic.kf.setImage(with: url)
        }
    }
    
    func initUI(){
        
        contentView.addSubview(bigPic)
        
        warnBg.cornerRadius = 8*CGFloat.widthSize()
        warnBg.backgroundColor = .whiteColor
        warnBg.isHidden = true
        contentView.addSubview(warnBg)
        
        leftIma.image = UIImage(named: "mydevice_bug")
        warnBg.addSubview(leftIma)
        
        titleLabel.textColor = .redColor40
        titleLabel.font = .textFont_14_bold
        titleLabel.textAlignment = .left
        titleLabel.text = "警告"
        warnBg.addSubview(titleLabel)
        
        timeLabel.textColor = .grayColor66
        timeLabel.text = "14:53"
        timeLabel.font = .textFont_14_medium
        timeLabel.textAlignment = .right
        warnBg.addSubview(timeLabel)
        
        descLabel.textAlignment = .left
        descLabel.textColor = .blackColor22
        descLabel.font = .textFont_14_medium
        descLabel.numberOfLines = 0
        descLabel.text = ""
        warnBg.addSubview(descLabel)
        
        
        bigPic.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(152*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-92*CGFloat.widthSize())
        }
        
        warnBg.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.top.equalTo(bigPic.snp.bottom)
            $0.height.equalTo(92*CGFloat.widthSize())
        }
        
        leftIma.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(12*CGFloat.widthSize())
            $0.width.height.equalTo(20*CGFloat.widthSize())
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(leftIma.snp.trailing).offset(4*CGFloat.widthSize())
            $0.centerY.equalTo(leftIma)
        }
        
        timeLabel.snp.makeConstraints{
            $0.centerY.equalTo(leftIma)
            $0.trailing.equalToSuperview().inset(12*CGFloat.widthSize())
        }
        
        descLabel.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview().inset(12*CGFloat.widthSize())
            $0.top.equalTo(leftIma.snp.bottom).offset(8*CGFloat.widthSize())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
