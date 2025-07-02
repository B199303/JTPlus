//
//  MyDeviceHeaderCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/20.
//

import UIKit
import JXPageControl

class MyDeviceHeaderCell: UICollectionViewCell {
    let scrollView = UIScrollView()
    let todayView = MyDeviceHeaderContentView()
    let weekView = MyDeviceHeaderContentView()
    let pageControl = JXPageControlEllipse()
    let contentWidth = CGFloat.screenWidth - 40*CGFloat.widthSize()
    var onTouch:(() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data:DeviceMetricsData){
        if let today = data.todayMetrics{
            self.todayView.bind(data: today)
        }
        if let week = data.curWeekMetrics{
            self.weekView.bind(data: week)
        }
    }
    
    @objc func touchView(){
        self.onTouch?()
    }
    
    func initUI(){
        
        scrollView.contentSize = CGSize(width: contentWidth*2, height: 105*CGFloat.widthSize())
        scrollView.backgroundColor = .whiteColor
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.cornerRadius = 8*CGFloat.widthSize()
        
        scrollView.delegate = self
        contentView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.top.equalToSuperview()
            $0.height.equalTo(105*CGFloat.widthSize())
        }
        
        let bgView = UIView()
        scrollView.addSubview(bgView)
        bgView.snp.makeConstraints{
            $0.leading.top.equalToSuperview()
            $0.width.equalTo(2*contentWidth)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(105*CGFloat.widthSize())
        }
        
        
       
        todayView.numTitle.text = "当日"
        todayView.addTarget(self, action: #selector(touchView), for: .touchUpInside)
        bgView.addSubview(todayView)
        todayView.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(contentWidth)
        }
        
        weekView.addTarget(self, action: #selector(touchView), for: .touchUpInside)
        weekView.numTitle.text = "本周"
        bgView.addSubview(weekView)
        weekView.snp.makeConstraints{
            $0.leading.equalTo(todayView.snp.trailing)
            $0.top.bottom.width.equalTo(todayView)
        }
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.tintColor = .yellow
        pageControl.activeColor = .greenColor30
        pageControl.inactiveColor = .greenColor30
        pageControl.inactiveSize = CGSize(width: 5*CGFloat.widthSize(), height: 5*CGFloat.widthSize())
        pageControl.activeSize = CGSize(width: 10*CGFloat.widthSize(), height: 5*CGFloat.widthSize())
        contentView.addSubview(pageControl)
        pageControl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8*CGFloat.widthSize())
            $0.width.equalTo(20*CGFloat.widthSize())
            $0.height.equalTo(8*CGFloat.widthSize())
        }
    }
}

extension MyDeviceHeaderCell: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / contentWidth
        let currentPage = Int(round(progress))
        self.pageControl.progress = progress
    }
}

class MyDeviceHeaderContentView: UIButton {
    let capacityTitle = MyDeviceHeaderTitleView()
    let nitrogenTitle = MyDeviceHeaderTitleView()
    let electriTitle = MyDeviceHeaderTitleView()
    let line = UIView()
    let numTitle = UILabel()
    let capacityNum = UILabel()
    let nitrogenNum = UILabel()
    let electriNum =  UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func bind(data:DeviceMetricsContentData){
        self.capacityNum.text = "\(data.capacity)"
        self.nitrogenNum.text = "\(data.nitrogenConsumption)"
        self.electriNum.text = "\(data.powerConsumption)"
    }
    
    func initUI(){
        addSubview(capacityTitle)
        addSubview(nitrogenTitle)
        addSubview(electriTitle)
        addSubview(line)
        addSubview(numTitle)
        addSubview(capacityNum)
        addSubview(nitrogenNum)
        addSubview(electriNum)
        
        capacityTitle.bind(imaStr: IconFontName.cap.rawValue, fontColor: .greenColor30, titleStr: "产能(k)")
        nitrogenTitle.bind(imaStr: IconFontName.jar.rawValue, fontColor: .greenColor30, titleStr: "氮耗(m³)")
        electriTitle.bind(imaStr: IconFontName.ele.rawValue, fontColor: .greenColor30, titleStr: "电耗(kw/h)")
        
        line.backgroundColor = .grayColorEE
        
        numTitle.textColor = .grayColor6D
        numTitle.textAlignment = .left
        numTitle.font = .textFont_14_medium
        
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
        
        capacityTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(38*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(15*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
            $0.width.equalTo(90*CGFloat.widthSize())
        }
        
        nitrogenTitle.snp.makeConstraints{
            $0.leading.equalTo(capacityTitle.snp.trailing)
            $0.top.height.width.equalTo(capacityTitle)
        }
        
        electriTitle.snp.makeConstraints{
            $0.leading.equalTo(nitrogenTitle.snp.trailing)
            $0.top.height.width.equalTo(capacityTitle)
        }
        
        line.snp.makeConstraints{
            $0.top.equalToSuperview().offset(43*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(10*CGFloat.widthSize())
            $0.height.equalTo(CGFloat.widthSize())
        }
        
        numTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10*CGFloat.widthSize())
            $0.top.equalTo(line.snp.bottom).offset(16*CGFloat.widthSize())
            $0.height.equalTo(20*CGFloat.widthSize())
        }
        
        capacityNum.snp.makeConstraints{
            $0.centerY.equalTo(numTitle)
            $0.centerX.equalTo(capacityTitle)
        }
        
        nitrogenNum.snp.makeConstraints{
            $0.centerY.equalTo(numTitle)
            $0.centerX.equalTo(nitrogenTitle)
        }
        
        electriNum.snp.makeConstraints{
            $0.centerY.equalTo(numTitle)
            $0.centerX.equalTo(electriTitle)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyDeviceHeaderTitleView: UIView {
    let ima = UIImageView()
    let title = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func bind(imaStr:String, fontColor:UIColor,  titleStr:String){
        ima.image = CommonIconFont.iconfontToImage(iconText: imaStr, fontSize: 20, fontColor: fontColor).image
        title.text = titleStr
    }
    
    func initUI(){
        addSubview(title)
        addSubview(ima)
      
        title.textAlignment = .left
        title.textColor = .blackColor33
        title.font = .textFont_14_medium
     
        title.snp.makeConstraints{
            $0.centerX.equalTo(self.snp.centerX).offset(6*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
        }
   
        ima.snp.makeConstraints{
            $0.trailing.equalTo(title.snp.leading).offset(-5*CGFloat.widthSize())
            $0.height.width.equalTo(11*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
