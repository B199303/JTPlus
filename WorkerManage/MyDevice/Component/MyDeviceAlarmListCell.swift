//
//  MyDeviceAlarmListCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/25.
//

import UIKit

class MyDeviceAlarmListCell: UITableViewCell {
    let bgView = UIView()
    let timeLabel = UILabel()
    let timeContent = UILabel()
    let alarmTitle = UILabel()
    let alarmContent = UILabel()
    let line = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        initUI()
    }
    
    func bind(data:DeviceAlarmListData){
        self.timeContent.text = data.alarmTime
        self.alarmContent.text = data.alarmContent
    }
    
    func initUI(){
        bgView.backgroundColor = .whiteColor
        contentView.addSubview(bgView)
        
        timeLabel.font = .textFont_14_medium
        timeLabel.textColor = .blackColor
        timeLabel.textAlignment = .left
        timeLabel.text = "告警时间："
        bgView.addSubview(timeLabel)
        
        timeContent.text = "2025-06-23 15:15:15"
        timeContent.font = .textFont_14_medium
        timeContent.textColor = .blackColor
        timeContent.textAlignment = .left
        bgView.addSubview(timeContent)
        
        alarmTitle.text = "告警内容："
        alarmTitle.font = .textFont_14_medium
        alarmTitle.textColor = .blackColor
        alarmTitle.textAlignment = .left
        bgView.addSubview(alarmTitle)
        
        alarmContent.numberOfLines = 0
        alarmContent.font = .textFont_14_medium
        alarmContent.textColor = .blackColor
        alarmContent.textAlignment = .left
        alarmContent.text = "告警内容告警内容告警内容告警内容告警内 容告警内容告警内容告警内容告警内容告警 内容告警内容"
        bgView.addSubview(alarmContent)
        
        line.backgroundColor = .grayColorEE
        bgView.addSubview(line)
        
        bgView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(CGFloat.widthSize())
        }
        
        timeLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
            $0.width.equalTo(70*CGFloat.widthSize())
        }
        
        timeContent.snp.makeConstraints{
            $0.leading.equalTo(timeLabel.snp.trailing)
            $0.centerY.equalTo(timeLabel)
        }
        
        alarmTitle.snp.makeConstraints{
            $0.leading.height.width.equalTo(timeLabel)
            $0.top.equalTo(timeLabel.snp.bottom).offset(4*CGFloat.widthSize())
        }
        
        alarmContent.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(4*CGFloat.widthSize())
            $0.leading.equalTo(alarmTitle.snp.trailing)
            $0.trailing.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-10*CGFloat.widthSize())
        }
        
        line.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(CGFloat.widthSize())
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
