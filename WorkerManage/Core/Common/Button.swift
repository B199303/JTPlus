//
//  Button.swift
//  WorkerManage
//
//  Created by BL L on 2022/9/2.
//

import UIKit

@IBDesignable
class ExpandedTouchAreaButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBInspectable var margin:CGFloat = 20.0
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}
