//
//  MyDeviceDetailShowView.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/30.
//

import UIKit

class MyDeviceDetailShowView: UIView {
    let bgView = UIView()
    let circleView = UIButton()
    let localView = MyDeviceDetailListView()
    let nameView = MyDeviceDetailListView()
    let codeView = MyDeviceDetailListView()
    let typeNumView = MyDeviceDetailListView()
    let dateView = MyDeviceDetailListView()
    
    var onTouch:(() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        initUI()
    }
    
    @objc func touch(){
        self.onTouch?()
    }
    
    func bind(show:Bool){
        if show{
            circleView.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.right.rawValue, fontSize: 20, fontColor: .grayColor99).image, for: .normal)
        }else{
            circleView.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.left.rawValue, fontSize: 20, fontColor: .grayColor99).image, for: .normal)
        }
    }
    
    func bind(detail:DeviceDetailData){
        localView.rightContent.text = detail.deviceLocation
        nameView.rightContent.text = detail.deviceName
        codeView.rightContent.text = detail.deviceEncoding
        typeNumView.rightContent.text = detail.deviceModel
        dateView.rightContent.text = detail.manufactureDate
    }
    
    func initUI(){
        bgView.backgroundColor = .whiteColor
        bgView.addRoundedCorner(with: 8*CGFloat.widthSize(), at: [.topLeft, .bottomLeft])
        addSubview(bgView)
        
        circleView.cornerRadius = 20*CGFloat.widthSize()
        circleView.backgroundColor = .whiteColor
        circleView.setImage(CommonIconFont.iconfontToImage(iconText: IconFontName.left.rawValue, fontSize: 20, fontColor: .grayColor99).image, for: .normal)
        circleView.addTarget(self, action: #selector(touch), for: .touchUpInside)
        addSubview(circleView)
        
        bgView.addSubview(localView)
        bgView.addSubview(nameView)
        bgView.addSubview(codeView)
        bgView.addSubview(typeNumView)
        bgView.addSubview(dateView)
        
        localView.nameLabel.text = "设备位置："
        localView.rightContent.text = "厂房1号生产线"
        
        nameView.nameLabel.text = "设备名称："
        nameView.rightContent.text = "JTR12138"
        
        codeView.nameLabel.text = "设备编码："
        codeView.rightContent.text = "JTR-2024-1326664"
        
        typeNumView.nameLabel.text = "设备型号："
        typeNumView.rightContent.text = "JTR-256"
        
        dateView.nameLabel.text = "出厂日期："
        dateView.rightContent.text = "2024-03-16"
        
        bgView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.bottom.trailing.equalToSuperview()
        }
        
        circleView.snp.makeConstraints{
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(40*CGFloat.widthSize())
        }
        
        localView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(9*CGFloat.widthSize())
            $0.height.equalTo(17*CGFloat.widthSize())
            $0.trailing.equalToSuperview()
        }
        
        nameView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalTo(localView.snp.bottom).offset(4*CGFloat.widthSize())
            $0.height.equalTo(17*CGFloat.widthSize())
            $0.trailing.equalToSuperview()
        }
        
        codeView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalTo(nameView.snp.bottom).offset(4*CGFloat.widthSize())
            $0.height.equalTo(17*CGFloat.widthSize())
            $0.trailing.equalToSuperview()
        }
        
        typeNumView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalTo(codeView.snp.bottom).offset(4*CGFloat.widthSize())
            $0.height.equalTo(17*CGFloat.widthSize())
            $0.trailing.equalToSuperview()
        }
        
        dateView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.top.equalTo(typeNumView.snp.bottom).offset(4*CGFloat.widthSize())
            $0.height.equalTo(17*CGFloat.widthSize())
            $0.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MyDeviceDetailListView: UIView {
    let nameLabel = UILabel()
    let rightContent = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        initUI()
    }
    
    func initUI(){
        nameLabel.textColor = .grayColor66
        nameLabel.font = .textFont_12_medium
        nameLabel.textAlignment = .left
        addSubview(nameLabel)
        
        rightContent.textAlignment = .left
        rightContent.textColor = .blackColor22
        rightContent.font = .textFont_12_medium
        addSubview(rightContent)
        
        nameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.width.equalTo(60*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
        }
        
        rightContent.snp.makeConstraints{
            $0.leading.equalTo(nameLabel.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
