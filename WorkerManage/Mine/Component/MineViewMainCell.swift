//
//  MineViewMainCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/12.
//

import UIKit

class MineViewMainCell: UITableViewCell {
    let leftIma = UIImageView()
    let content = UILabel()
    let rightArrow = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        initUI()
    }
    
    func initUI(){
        contentView.addSubview(leftIma)
        contentView.addSubview(content)
        contentView.addSubview(rightArrow)
        
        content.textAlignment = .left
        content.textColor = .blackColor
        content.font = .textFont_14_medium
        content.text = "关于劲拓家"
        
        rightArrow.image = CommonIconFont.iconfontToImage(iconText: IconFontName.right.rawValue, fontSize: 20, fontColor: .grayColor99).image
        
        leftIma.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20*CGFloat.widthSize())
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20*CGFloat.widthSize())
        }
        
        content.snp.makeConstraints{
            $0.leading.equalTo(leftIma.snp.trailing).offset(12*CGFloat.widthSize())
            $0.centerY.equalTo(leftIma)
        }
        
        rightArrow.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.width.height.equalTo(20*CGFloat.widthSize())
            $0.centerY.equalTo(leftIma)
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
