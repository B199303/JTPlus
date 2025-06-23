//
//  MessageRecordListCell.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/21.
//

import UIKit

class MessageRecordListCell: UITableViewCell {
    let timeLabel = UILabel()
    let bgView = UIView()
    let numberLabel = UILabel()
    let idLabel = UILabel()
    let contentLabel = UILabel()
    let contentTime = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        initUI()
    }
    
    func bind(data:AlarmListContent){
        self.timeLabel.text = data.alarmTime
        self.numberLabel.text = "设备型号：\(data.deviceModel)"
        self.idLabel.text = "设备ID：\(data.deviceNumber)"
        self.contentLabel.text = "告警内容：\(data.msg)"
        self.contentTime.text = "告警时间：\(data.alarmTime)"
    }
    
    func initUI(){
        timeLabel.textColor = .grayColor80
        timeLabel.font = .textFont_12_regular
        timeLabel.textAlignment = .center
        timeLabel.text = "12月5日 上午08:44"
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(17)
        }
        
        bgView.backgroundColor = .grayColor4D
        bgView.cornerRadius = 4
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(timeLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
        
        numberLabel.textColor = .grayColorC4
        numberLabel.font = .textFont_12_regular
        numberLabel.textAlignment = .left
        numberLabel.text = "设备型号：波峰焊01型号"
        bgView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(17)
        }
        
        idLabel.textColor = .grayColorC4
        idLabel.font = .textFont_12_regular
        idLabel.textAlignment = .left
        idLabel.text = "设备ID：673214687"
        bgView.addSubview(idLabel)
        idLabel.snp.makeConstraints{
            $0.leading.equalTo(numberLabel)
            $0.top.equalTo(numberLabel.snp.bottom).offset(6)
            $0.height.equalTo(17)
        }
        
        contentLabel.textColor = .grayColorC4
        contentLabel.font = .textFont_12_regular
        contentLabel.textAlignment = .left
        contentLabel.text = "告警内容：通讯失败"
        contentLabel.numberOfLines = 0
        bgView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(idLabel.snp.bottom).offset(6)
        }
        
        contentTime.textColor = .grayColorC4
        contentTime.font = .textFont_12_regular
        contentTime.textAlignment = .left
        contentTime.text = "告警时间：2023/07/06 14:16:19"
        bgView.addSubview(contentTime)
        contentTime.snp.makeConstraints{
            $0.leading.equalTo(numberLabel)
            $0.top.equalTo(contentLabel.snp.bottom).offset(6)
            $0.height.equalTo(17)
            $0.bottom.equalToSuperview().offset(-6)
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
