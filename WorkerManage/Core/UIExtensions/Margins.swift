//
//  Margins.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/4.
//

import UIKit
import DeviceKit

extension CGFloat{
    public static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    public static let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    public static var statusBarHeight: CGFloat {
        if Device.current.hasFaceId {
            return 44
        }
        return 20
    }
    public static var topSpace: CGFloat {
        return statusBarHeight + 44
    }
    
    public static var bottomSpace: CGFloat {
        if Device.current.hasFaceId {
            return 49 + bottomSafeSpace
        }
        return 49
    }
    
    public static var bottomSafeSpace: CGFloat {
        if Device.current.hasFaceId {
            return 34
        }
        return 0
    }
    
    public static var topSafeSpace: CGFloat {
        if Device.current.hasFaceId {
            return 44
        }
        return 0
    }
    
    public static func autoFix(value: CGFloat) -> CGFloat {
        let result:CGFloat = value*screenWidth/375
        return result
    }
    
    
    public static func widthSize() -> CGFloat {
        let result:CGFloat = screenWidth/375
        return result
    }
    
    public static func heightSize() -> CGFloat {
        let result:CGFloat = screenHeight/667
        return result
    }
}

extension CGFloat {
    public static let cornerRadius05x: CGFloat = 2
    public static let cornerRadius1x: CGFloat = 4
    public static let cornerRadius2x: CGFloat = 8
    public static let cornerRadius3x: CGFloat = 12
    public static let cornerRadius4x: CGFloat = 16

    public static let cornerRadius2: CGFloat = 2
    public static let cornerRadius4: CGFloat = 4
    public static let cornerRadius8: CGFloat = 8
    public static let cornerRadius12: CGFloat = 12
    public static let cornerRadius16: CGFloat = 16

    public static let margin05x: CGFloat = 2
    public static let margin1x: CGFloat = 4
    public static let margin2x: CGFloat = 8
    public static let margin3x: CGFloat = 12
    public static let margin4x: CGFloat = 16
    public static let margin6x: CGFloat = 24
    public static let margin8x: CGFloat = 32
    public static let margin10x: CGFloat = 40
    public static let margin12x: CGFloat = 48

    public static let margin2: CGFloat = 2
    public static let margin4: CGFloat = 4
    public static let margin6: CGFloat = 6
    public static let margin8: CGFloat = 8
    public static let margin12: CGFloat = 12
    public static let margin16: CGFloat = 16
    public static let margin24: CGFloat = 24
    public static let margin32: CGFloat = 32
    public static let margin40: CGFloat = 40
    public static let margin48: CGFloat = 48

    public static let marginTextSide: CGFloat = 44

    public static let heightOnePixel: CGFloat = 1 / UIScreen.main.scale
    public static let heightOneDp: CGFloat = 1
    public static let heightSingleLineCell: CGFloat = 44
    public static let heightCell48: CGFloat = 48
    public static let heightDoubleLineCell: CGFloat = 60
    public static let heightButton: CGFloat = 50
    public static let heightBottomWrapperBar: CGFloat = 98

    public static let iconSize20: CGFloat = 20
    public static let iconSize24: CGFloat = 24
}
