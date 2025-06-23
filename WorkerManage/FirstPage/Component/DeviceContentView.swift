//
//  DeviceContentView.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/21.
//

import UIKit

class DeviceContentView: UIView {
    
    let bgIma = UIImageView()
    let nameLabel = UILabel()

    init(){
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
//        self.backgroundColor = .blackColor40
        
        addSubview(bgIma)
        bgIma.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        nameLabel.font = .textFont_16_regular
        nameLabel.textAlignment = .left
        nameLabel.textColor = .whiteColor
        nameLabel.text = "回流焊"
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(14)
            $0.top.equalToSuperview().offset(8)
        }
    }

}
