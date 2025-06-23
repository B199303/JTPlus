//
//  MineSexSelectView.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/13.
//

import UIKit

class MineSexSelectView: UIView {
    let topButton = UIButton()
    let bottomButton = UIButton()
    
    var onTouch:((Int) -> ())?

    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        topButton.setTitleColor(.blackColor33, for: .normal)
        topButton.titleLabel?.font = .textFont_14_medium
        topButton.setTitle("男", for: .normal)
        topButton.tag = 1
        topButton.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        addSubview(topButton)
        
        bottomButton.setTitleColor(.blackColor33, for: .normal)
        bottomButton.titleLabel?.font = .textFont_14_medium
        bottomButton.setTitle("女", for: .normal)
        bottomButton.tag = 2
        bottomButton.addTarget(self, action: #selector(touch(button:)), for: .touchUpInside)
        addSubview(bottomButton)
        
        topButton.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48*CGFloat.widthSize())
        }
        
        bottomButton.snp.makeConstraints{
            $0.top.equalTo(topButton.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(48*CGFloat.widthSize())
        }
    }
    
    @objc func touch(button:UIButton){
        self.onTouch?(button.tag)
    }

}
