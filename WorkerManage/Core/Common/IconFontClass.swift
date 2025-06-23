//
//  IconFontClass.swift
//  WorkerManage
//
//  Created by BL L on 2024/5/20.
//

import UIKit

class IconFontClass: NSObject {

}

public enum IconFontName: String {
    case aboutUs = "\u{e602}"
    case update = "\u{e663}"
    case see = "\u{e87d}"
    case nosee = "\u{e901}"
    case jar = "\u{e648}"
    case ele = "\u{e649}"
    case home = "\u{e647}"
    case mineRight = "\u{e646}"
    case homeRight = "\u{e645}"
    case minehead = "\u{e643}"
    case loginOut = "\u{e65a}"
    case myPage = "\u{e642}"
    case imagePlace = "\u{e70a}"
    case produce = "\u{e662}"
    case edit = "\u{e616}"
    case device = "\u{e9fd}"
    case delete = "\u{e797}"
    case my = "\u{e603}"
    case tip = "\u{e661}"
    case key = "\u{e6ed}"
    case cap = "\u{e63d}"
    case right = "\u{e63c}"
    case left = "\u{e63b}"
    case plan = "\u{e63a}"
    case bug = "\u{e639}"
    case wifi = "\u{e635}"
    case history = "\u{e633}"
    case manage = "\u{e634}"
    case add = "\u{e632}"
    case scancode = "\u{e631}"
    case message = "\u{e630}"
    case close = "\u{e676}"
    case sex = "\u{e64a}"
    case unlink = "\u{e64c}"
    case record = "\u{e60a}"
}

class CommonIconFont {
    class func iconFontToLabel(frame: CGRect = .zero, fontSize: CGFloat, fontName: String, iconName: String = "") -> UILabel{
        let lab = UILabel(frame: frame)
        lab.font = UIFont.init(name: "iconfont", size: fontSize)
        lab.text = fontName
        lab.isUserInteractionEnabled = true
        return lab
    }
    
    class func iconfontToImage(iconText: String, fontSize: CGFloat, fontColor: UIColor) -> UIImageView {
        // 这里我使用的R.Swift资源管理， 你可以直接用:UIFont(name: "你的iconfont名称", size: fontSize)
        let font = UIFont.init(name: "iconfont", size: fontSize)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: fontSize, height: fontSize), false, 0)
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: fontColor]
        let attributedString = NSAttributedString(string: iconText, attributes: attributes as [NSAttributedString.Key : Any])
        attributedString.draw(at: CGPoint(x: 0, y: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 如果不想用UIIimageView , 这里直接返回image即可。 return image
        let imageV = UIImageView(image: image)
        imageV.isUserInteractionEnabled = true
        return imageV
    }
    
}
