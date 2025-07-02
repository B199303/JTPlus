//
//  MyDeviceDetailProgressCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/27.
//

import UIKit

class MyDeviceDetailProgressCell: UITableViewCell {
    let leftBg = UIView()
    let leftTitle = UILabel()
    let leftHour = UILabel()
    
    let rightBg = UIView()
    let rightTitle = UILabel()
    let rightHour = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        initUI()
    }
    
    func bind(data:DeviceMetricsData){
        if let leftNum = data.todayMetrics?.runDuration{
            var timeText = ""
            if leftNum > 60{
                timeText = "\(leftNum/60)h\(leftNum%60)m"
            }else{
                timeText = "\(leftNum)m"
            }
            self.leftHour.text = timeText
        }
        if let rightNum = data.curWeekMetrics?.runDuration{
            var timeText = ""
            if rightNum > 60{
                timeText = "\(rightNum/60)h\(rightNum%60)m"
            }else{
                timeText = "\(rightNum)m"
            }
            self.rightHour.text = timeText
        }
    }
    
    func initUI(){
        leftBg.backgroundColor = .whiteColor
        leftBg.cornerRadius = 8*CGFloat.widthSize()
        contentView.addSubview(leftBg)
        
        leftTitle.textAlignment = .left
        leftTitle.font = .textFont_14_medium
        leftTitle.textColor = .grayColor66
        leftTitle.text = "今日运行时长"
        leftBg.addSubview(leftTitle)
        
        let leftCircle = CircularProgressView(clockwise: false, lineColor: .blueColor51)
        leftBg.addSubview(leftCircle)
        
        leftHour.textAlignment = .center
        leftHour.font = .textFont_16_bold
        leftHour.textColor = .blackColor22
        leftHour.text = "24h"
        leftCircle.addSubview(leftHour)
        
        leftBg.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.width.equalTo(160*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
        }
        
        leftTitle.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(12*CGFloat.widthSize())
        }
        
        leftCircle.snp.makeConstraints{
            $0.height.width.equalTo(106*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(42*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
        }
        
        leftHour.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        rightBg.backgroundColor = .whiteColor
        rightBg.cornerRadius = 8*CGFloat.widthSize()
        contentView.addSubview(rightBg)
        
        rightTitle.textAlignment = .left
        rightTitle.font = .textFont_14_medium
        rightTitle.textColor = .grayColor66
        rightTitle.text = "本周运行时长"
        rightBg.addSubview(rightTitle)
        
        let rightCircle = CircularProgressView(clockwise: true, lineColor: .blueColor1E)
        rightBg.addSubview(rightCircle)
        
        rightHour.textAlignment = .center
        rightHour.font = .textFont_16_bold
        rightHour.textColor = .blackColor22
        rightHour.text = "8760h"
        rightCircle.addSubview(rightHour)
        
        rightBg.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.width.equalTo(160*CGFloat.widthSize())
        }
        
        rightTitle.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(12*CGFloat.widthSize())
        }
        
        rightCircle.snp.makeConstraints{
            $0.height.width.equalTo(106*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(42*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
        }
        
        rightHour.snp.makeConstraints{
            $0.center.equalToSuperview()
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
