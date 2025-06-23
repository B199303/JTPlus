//
//  PersonalBaseMessageCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/13.
//

import UIKit

class PersonalBaseMessageCell: UITableViewCell {
    let accountView = PersonalBaseMessageContentView()
    let passwordView = PersonalBaseMessageContentView()
    let headView = PersonalBaseMessageHeadView()
    let nickNameView = PersonalBaseMessageContentView()
    let genderView = PersonalBaseMessageContentView()
    let areaView = PersonalBaseMessageContentView()
    
    var onTouch:((Int) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func gotoDetail(button:UIButton){
        self.onTouch?(button.tag)
    }
    
    func bind(data:UserInfoData){
        accountView.bind(left: "账号", right: data.account, isDetail: false)
        if data.avatar != ""{
            let url = URL(string: data.avatar)
            self.headView.rightIma.kf.setImage(with: url)
        }else{
            self.headView.rightIma.image = UIImage(named: "mine_head")
        }
        nickNameView.bind(left: "昵称", right: data.name)
        if data.sex == 1{
            genderView.bind(left: "性别", right: "男")
        }else if data.sex == 2{
            genderView.bind(left: "性别", right: "女")
        }else{
            genderView.bind(left: "性别", right: "")
        }
        areaView.bind(left: "国家/地区", right: data.region, isDetail: false)
    }
    
    func initUI(){
        contentView.addSubview(accountView)
        
        passwordView.bind(left: "修改密码", right: "")
        passwordView.tag = 1
        passwordView.addTarget(self, action: #selector(gotoDetail(button:)), for: .touchUpInside)
        contentView.addSubview(passwordView)
        
        headView.leftText.text = "头像"
        headView.tag = 2
        headView.addTarget(self, action: #selector(gotoDetail(button:)), for: .touchUpInside)
        headView.rightIma.image = UIImage(named: "mine_head")
        contentView.addSubview(headView)
        
        nickNameView.tag = 3
        nickNameView.addTarget(self, action: #selector(gotoDetail(button:)), for: .touchUpInside)
        contentView.addSubview(nickNameView)
        
        genderView.tag = 4
        genderView.addTarget(self, action: #selector(gotoDetail(button:)), for: .touchUpInside)
        genderView.rightArrow.image = CommonIconFont.iconfontToImage(iconText: IconFontName.sex.rawValue, fontSize: 20, fontColor: .grayColor99).image
        contentView.addSubview(genderView)
        
        areaView.tag = 5
        areaView.addTarget(self, action: #selector(gotoDetail(button:)), for: .touchUpInside)
        contentView.addSubview(areaView)
        
        accountView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(8*CGFloat.widthSize())
            $0.height.equalTo(54*CGFloat.widthSize())
        }
        
        passwordView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(accountView.snp.bottom)
            $0.height.equalTo(54*CGFloat.widthSize())
        }
        
        headView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(passwordView.snp.bottom)
            $0.height.equalTo(80*CGFloat.widthSize())
        }
        
        nickNameView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(headView.snp.bottom)
            $0.height.equalTo(54*CGFloat.widthSize())
        }
        
        genderView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nickNameView.snp.bottom)
            $0.height.equalTo(54*CGFloat.widthSize())
        }
        
        areaView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(genderView.snp.bottom)
            $0.height.equalTo(54*CGFloat.widthSize())
            $0.bottom.equalToSuperview()
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


class PersonalBaseMessageContentView: UIButton {
    let leftText = UILabel()
    let rightContent = UILabel()
    let rightArrow = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(left:String, right:String, isDetail:Bool? = true){
        self.leftText.text = left
        self.rightContent.text = right
        if let isDetail = isDetail{
            if !isDetail{
                self.rightArrow.isHidden = true
                rightContent.snp.remakeConstraints{
                    $0.centerY.equalTo(leftText)
                    $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
                }
            }
        }
    }
    
    func initUI(){
        addSubview(leftText)
        addSubview(rightContent)
        addSubview(rightArrow)
        
        leftText.font = .textFont_16_medium
        leftText.textColor = .blackColor
        leftText.textAlignment = .left
        
        rightContent.font = .textFont_14_medium
        rightContent.textColor = .grayColor99
        rightContent.textAlignment = .right
        
        rightArrow.image = CommonIconFont.iconfontToImage(iconText: IconFontName.right.rawValue, fontSize: 20, fontColor: .grayColor99).image
        
        leftText.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(16*CGFloat.widthSize())
            $0.height.equalTo(22*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
        }
        
        rightContent.snp.makeConstraints{
            $0.centerY.equalTo(leftText)
            $0.trailing.equalToSuperview().offset(-56*CGFloat.widthSize())
        }
        
        rightArrow.snp.makeConstraints{
            $0.width.height.equalTo(20*CGFloat.widthSize())
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.centerY.equalTo(leftText)
        }
    }
}

class PersonalBaseMessageHeadView: UIButton {
    let leftText = UILabel()
    let rightIma = UIImageView()
    let rightArrow = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        addSubview(leftText)
        addSubview(rightIma)
        addSubview(rightArrow)
        
        leftText.font = .textFont_16_medium
        leftText.textColor = .blackColor
        leftText.textAlignment = .left
        
        rightIma.backgroundColor = .blue
        rightIma.cornerRadius = 24*CGFloat.widthSize()
        
        rightArrow.image = CommonIconFont.iconfontToImage(iconText: IconFontName.right.rawValue, fontSize: 20, fontColor: .grayColor99).image
        
        leftText.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.height.equalTo(22*CGFloat.widthSize())
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
        }
        
        rightIma.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-56*CGFloat.widthSize())
            $0.width.height.equalTo(48*CGFloat.widthSize())
            $0.bottom.top.equalToSuperview().inset(16*CGFloat.widthSize())
        }
        
        rightArrow.snp.makeConstraints{
            $0.width.height.equalTo(20*CGFloat.widthSize())
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.centerY.equalTo(leftText)
        }
    }
}
