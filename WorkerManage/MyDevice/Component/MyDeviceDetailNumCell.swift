//
//  MyDeviceDetailNumCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/23.
//

import UIKit
import JXPageControl

class MyDeviceDetailNumCell: UITableViewCell {
    let scrollView = UIScrollView()
    let todayView = MyDeviceHeaderContentView()
    let weekView = MyDeviceHeaderContentView()
    let pageControl = JXPageControlEllipse()
    let contentWidth = CGFloat.screenWidth - 40*CGFloat.widthSize()
    
    var onTouch:(() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        initUI()
    }
    
    func bind(data:DeviceMetricsData){
        if let today = data.todayMetrics{
            self.todayView.bind(data: today)
        }
        if let week = data.curWeekMetrics{
            self.weekView.bind(data: week)
        }
    }
    
    @objc func touch(){
        self.onTouch?()
    }
    
    func initUI(){
        let contentWidth = CGFloat.screenWidth - 40*CGFloat.widthSize()
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
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.height.equalTo(105*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
        }
        
        let bgView = UIView()
        scrollView.addSubview(bgView)
        bgView.snp.makeConstraints{
            $0.leading.top.equalToSuperview()
            $0.width.equalTo(2*contentWidth)
            $0.height.equalTo(105*CGFloat.widthSize())
            $0.trailing.equalToSuperview()
        }
       
        todayView.numTitle.text = "当日"
        todayView.addTarget(self, action: #selector(touch), for: .touchUpInside)
        bgView.addSubview(todayView)
        todayView.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(contentWidth)
        }

        weekView.numTitle.text = "本周"
        weekView.addTarget(self, action: #selector(touch), for: .touchUpInside)
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

extension MyDeviceDetailNumCell: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / contentWidth
        self.pageControl.progress = progress
    }
}
