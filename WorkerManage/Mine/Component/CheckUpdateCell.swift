//
//  CheckUpdateCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/15.
//

import UIKit

class CheckUpdateCell: UITableViewCell {
    let bgView = UIView()
    
    let updateTitle = UILabel()
    let updateTime = UILabel()
    let updateContet = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(data:CheckVersionData){
        var content = ""
        for item in data.versionInfo{
            if content != ""{
                let str = "\n[\(item.type)]\(item.desc)"
                content = content + str
            }else{
                let str = "[\(item.type)]\(item.desc)"
                content = content + str
            }
        }
        self.updateContet.text = content
        self.updateTitle.text = "v\(data.versionCode)"
        self.updateTime.text = data.updateTime
    }
    
    func initUI(){
        bgView.backgroundColor = .whiteColor
        bgView.cornerRadius = 8*CGFloat.widthSize()
        addSubview(bgView)
        
        updateTitle.textAlignment = .left
        updateTitle.font = .textFont_14_bold
        updateTitle.textColor = .blackColor
        updateTitle.text = "V1.0.3全新版本"
        bgView.addSubview(updateTitle)
        
        updateTime.textAlignment = .right
        updateTime.font = .textFont_14_medium
        updateTime.textColor = .grayColor66
        updateTime.text = "2025.06.25"
        bgView.addSubview(updateTime)
        
        updateContet.textAlignment = .left
        updateContet.textColor = .blackColor
        updateContet.font = .textFont_13_medium
        updateContet.numberOfLines = 0
        updateContet.text = "[新增功能] 新增功能新增功能新增功能新增功能新增功能"
        bgView.addSubview(updateContet)
        
        bgView.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview().inset(10*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
        }
        
        updateTitle.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(12*CGFloat.widthSize())
        }
        
        updateTime.snp.makeConstraints{
            $0.top.equalTo(updateTitle.snp.bottom).offset(7*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(16*CGFloat.widthSize())
        }
        
        updateContet.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16*CGFloat.widthSize())
            $0.top.equalTo(updateTime.snp.bottom).offset(9*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-11*CGFloat.widthSize())
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
