//
//  AboutUsViewController.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/15.
//

import UIKit

class AboutUsViewController: CustomNavigationBarController {
    let logoImage = UIImageView()
    let versionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于劲拓家"
        navBar.isHidden = false
        self.navBar.bottomLine.isHidden = false
        self.navBar.bottomLine.backgroundColor = .grayColorEF

        logoImage.backgroundColor = .blueColor48
        logoImage.cornerRadius = 12*CGFloat.widthSize()
        logoImage.image = UIImage(named: "logo")
        view.addSubview(logoImage)
        
        versionLabel.textColor = .grayColor80
        versionLabel.textAlignment = .center
        versionLabel.font = .textFont_14_medium
        versionLabel.text = "V1.0.0"
        view.addSubview(versionLabel)
        
        logoImage.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom).offset(80*CGFloat.widthSize())
            $0.width.height.equalTo(56*CGFloat.widthSize())
        }
        
        versionLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoImage.snp.bottom).offset(8*CGFloat.widthSize())
        }
    }

}
