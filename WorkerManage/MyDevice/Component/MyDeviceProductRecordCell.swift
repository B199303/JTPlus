//
//  MyDeviceProductRecordCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/24.
//

import UIKit

class MyDeviceProductRecordCell: UITableViewCell {
    let bgView = UIView()
    let dateLabel = UILabel()
    let capacityTitle = MyDeviceHeaderTitleView()
    let nitrogenTitle = MyDeviceHeaderTitleView()
    let electriTitle = MyDeviceHeaderTitleView()
    let line = UIView()
    let capacityNum = UILabel()
    let nitrogenNum = UILabel()
    let electriNum =  UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data:DeviceMetricsContentData){
        self.dateLabel.text = data.showDay
        self.capacityNum.text = "\(data.capacity)"
        self.nitrogenNum.text = "\(data.nitrogenConsumption)"
        self.electriNum.text = "\(data.powerConsumption)"
    }
    
    func initUI(){
        bgView.borderColor = .grayColor99
        bgView.borderWidth = CGFloat.widthSize()
        bgView.cornerRadius = 8*CGFloat.widthSize()
        contentView.addSubview(bgView)
        
        dateLabel.text = ""
        dateLabel.textColor = .blackColor33
        dateLabel.font = .textFont_14_bold
        dateLabel.textAlignment = .left
        bgView.addSubview(dateLabel)
        
        capacityTitle.bind(imaStr: IconFontName.cap.rawValue, fontColor: .greenColor30, titleStr: "产能(k)")
        nitrogenTitle.bind(imaStr: IconFontName.jar.rawValue, fontColor: .greenColor30, titleStr: "氮耗(m³)")
        electriTitle.bind(imaStr: IconFontName.ele.rawValue, fontColor: .greenColor30, titleStr: "电耗(kw/h)")
        bgView.addSubview(capacityTitle)
        bgView.addSubview(nitrogenTitle)
        bgView.addSubview(electriTitle)
        
        
        line.backgroundColor = .grayColorEE
        
        capacityNum.textColor = .blackColor
        capacityNum.textAlignment = .left
        capacityNum.font = .textFont_16_bold
        capacityNum.text = "350"
        
        nitrogenNum.textColor = .blackColor
        nitrogenNum.textAlignment = .left
        nitrogenNum.font = .textFont_16_bold
        nitrogenNum.text = "507"
        
        electriNum.textColor = .blackColor
        electriNum.textAlignment = .left
        electriNum.font = .textFont_16_bold
        electriNum.text = "3165"
        
        bgView.addSubview(line)
        bgView.addSubview(capacityNum)
        bgView.addSubview(nitrogenNum)
        bgView.addSubview(electriNum)
        
        bgView.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.height.equalTo(128*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(12*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        capacityTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(50*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
            $0.width.equalTo(90*CGFloat.widthSize())
        }
        
        nitrogenTitle.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.height.width.equalTo(capacityTitle)
        }
        
        electriTitle.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-30*CGFloat.widthSize())
            $0.top.height.width.equalTo(capacityTitle)
        }
        
        line.snp.makeConstraints{
            $0.top.equalToSuperview().offset(78*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(10*CGFloat.widthSize())
            $0.height.equalTo(CGFloat.widthSize())
        }
        
        capacityNum.snp.makeConstraints{
            $0.top.equalTo(line.snp.bottom).offset(16*CGFloat.widthSize())
            $0.centerX.equalTo(capacityTitle)
        }
        
        nitrogenNum.snp.makeConstraints{
            $0.centerY.equalTo(capacityNum)
            $0.centerX.equalTo(nitrogenTitle)
        }
        
        electriNum.snp.makeConstraints{
            $0.centerY.equalTo(capacityNum)
            $0.centerX.equalTo(electriTitle)
        }
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
