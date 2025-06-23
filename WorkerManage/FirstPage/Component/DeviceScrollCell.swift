//
//  DeviceScrollCell.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/21.
//

import UIKit

class DeviceScrollCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(deviceView)
        deviceView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview()
            $0.width.equalTo(275)
            $0.height.equalTo(400)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public lazy var deviceView: DeviceContentView = {
        let view = DeviceContentView()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
//        view.autoresizingMask = [
//            .flexibleWidth,
//            .flexibleTopMargin
//        ]
        return view
    }()
}
