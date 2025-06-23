//
//  CustomTextView.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/16.
//

import UIKit

class CustomTextView: UITextView {
    /// 占位文字
    var placeholder: String?
    /// 占位文字颜色
    var placeholderColor: UIColor? = UIColor.lightGray

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.font = UIFont.systemFont(ofSize: 15)
        // 使用通知监听文字改变
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(UIImage(named: "input_delete"), for: .normal)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // 如果有文字,就直接返回,不需要画占位文字
        if self.hasText {
            return
        }
        
        // 属性
        let attrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: self.placeholderColor as Any, NSAttributedString.Key.font: self.font!]
        
        // 文字
        var rect1 = rect
        rect1.origin.x = 5
        rect1.origin.y = 8
        rect1.size.width = rect1.size.width - 2*rect1.origin.x
        (self.placeholder! as NSString).draw(in: rect1, withAttributes: attrs)
    }
    
    @objc func textDidChange(_ note: Notification) {
        // 会重新调用drawRect:方法
        self.setNeedsDisplay()
    }
    
}
