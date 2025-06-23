//
//  LoginCell.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/23.
//

import UIKit

class LoginCell: UITableViewCell {
    private let titleIma = UIImageView()
    private let title = UILabel()
    let bottomIma = UIImageView()
    let nameView = LoginTextView()
    let passView = LoginTextView()
    let loginButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        title.textColor = .blackColor33
        title.textAlignment = .center
        title.font = .textFont_20_medium
        title.text = "劲拓家"
        contentView.addSubview(title)
        
        titleIma.image = UIImage(named: "logo")
        titleIma.cornerRadius = 12*CGFloat.widthSize()
        contentView.addSubview(titleIma)
        
        nameView.setName()
        contentView.addSubview(nameView)
        
        passView.setPassword()
        contentView.addSubview(passView)
        
        
        loginButton.setTitle("登录", for: .normal)
        loginButton.setTitleColor(.whiteColor, for: .normal)
        loginButton.titleLabel?.font = .textFont_16_bold
        loginButton.backgroundColor = .blueColor48
        loginButton.cornerRadius = 4
        contentView.addSubview(loginButton)
        
        
        titleIma.snp.makeConstraints{
            $0.top.equalToSuperview().offset(120*CGFloat.widthSize())
            $0.height.width.equalTo(72*CGFloat.widthSize())
            $0.centerX.equalToSuperview()
            
        }
        
        title.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleIma.snp.bottom).offset(4*CGFloat.widthSize())
            $0.height.equalTo(28*CGFloat.widthSize())
        }
        
        
        nameView.snp.makeConstraints{
            $0.top.equalTo(title.snp.bottom).offset(36*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(40*CGFloat.widthSize())
            $0.height.equalTo(57*CGFloat.widthSize())
        }
        
        passView.snp.makeConstraints{
            $0.top.equalTo(nameView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(40*CGFloat.widthSize())
            $0.height.equalTo(57*CGFloat.widthSize())
        }
        
        
        
        loginButton.snp.makeConstraints{
            $0.top.equalTo(passView.snp.bottom).offset(188*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview().inset(40*CGFloat.widthSize())
            $0.height.equalTo(48*CGFloat.widthSize())
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
