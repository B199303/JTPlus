//
//  UIImage.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import UIKit

extension UIImage {
    
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    public convenience init?(fromColor: UIColor, toColor: UIColor, size: CGSize, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let layer = CAGradientLayer()
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.frame = CGRect(origin: CGPoint.zero, size: size)
        layer.colors = [fromColor.cgColor, toColor.cgColor]
        
        var image: UIImage?
        
        UIGraphicsBeginImageContext(size);
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext();
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    @available(*, deprecated, message: "this method does not work with UIColor traits, use only with single colors")
    public func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        defer { UIGraphicsEndImageContext() }
        
        color.set()
        withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func getImageFromView(view: UIView) -> UIImage {
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(view.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
    class func cwQRCodeImage(content: String,
                             logo: UIImage? = nil,
                             logoFrame: CGRect = CGRect.zero,
                             size: CGFloat = -1,
                             highCorrection: Bool = false,
                             tintColor: UIColor? = nil) -> UIImage? {
        var retImage: UIImage? = nil
        var openHighCorrection = highCorrection
        
        // 如果要添加logo或者绘制颜色，自动开启高容错
        if logo != nil || tintColor != nil {
            openHighCorrection = true
        }
        let correctionLevel = openHighCorrection ? "H" : "M"
        
        // 生成二维码并设置纠错级别
        let outputImage = qrCodeOutputImage(content: content,
                                            correctionLevel: correctionLevel)
        if let output = outputImage {
            // 调整尺寸之后的二维码
            retImage = adjustHDQRCode(outputImage: output,
                                      size:size)
        }
        
        // 二维码着色
        if let mTintColor = tintColor {
            retImage = retImage?.cwModifyTintColor(tintColor: mTintColor)
        }
        
        // 二维码添加logo
        if let mLogo = logo {
            retImage = retImage?.cwAddLogoImage(image: mLogo,
                                                frame: logoFrame)
        }
        
        return retImage
    }
    
    
    /// 生成原始二维码CIImage
    ///
    /// - Parameters:
    ///   - content: 二维码包含的内容
    ///   - correctionLevel: 二维码纠错级别
    ///   ，调高纠错级别可以往上面加一个头像或者变色，但是识别速度也会降低
    /// - correctionLevel:
    ///   - 二维码纠错级别,通过调高二维码的纠错级别可以往上面加一个头像或者变色，但是识别速度也会降低
    ///   - L（低） 7％的码字可以被恢复。
    ///   - M（中） 15％的码字可以被恢复。
    ///   - Q（四分）25％的码字可以被恢复。
    ///   - H（高） 30％的码字可以被恢复。
    private class func qrCodeOutputImage(content: String,
                                         correctionLevel: String) -> CIImage? {
        // 初始化filter
        let data = content.data(using: .utf8)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // 设置内容
        qrFilter?.setValue(data, forKey: "inputMessage")
        qrFilter?.setValue(correctionLevel, forKey: "inputCorrectionLevel")
        return qrFilter?.outputImage
    }
    
    /// 调整二维码的尺寸并返回高清图片
    /// - Code:
    ///   - let transform = CGAffineTransform(scaleX: 5, y: 5)
    ///   - outputImage?.transformed(by: transform)
    ///
    /// - Parameters:
    ///   - outputImage: CIFilter生成的二维码
    ///   - size: 放大之后的尺寸
    /// - Returns: 返回调整之后的图片
    private class func adjustHDQRCode(outputImage: CIImage,
                                      size: CGFloat) -> UIImage? {
        
        let integralRect: CGRect = outputImage.extent.integral
        // 设置默认放大5倍
        var scale: CGFloat = 5.0
        if size != -1 {
            // 需要计算出最佳缩放比例
            scale = min(size/integralRect.width, size/integralRect.height)
        }
        
        let width = integralRect.width * scale
        let height = integralRect.height * scale
        
        let colorSpaceRef = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil,
                                  width: Int(width),
                                  height: Int(height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: colorSpaceRef,
                                  bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        let context = CIContext(options: nil)
        
        //放大重新绘制
        if let bitmapImage = context.createCGImage(outputImage,
                                                   from: integralRect) {
            bitmapRef?.interpolationQuality = .none
            bitmapRef?.scaleBy(x: scale, y: scale)
            bitmapRef?.draw(bitmapImage, in: integralRect)
        }
        
        let scaledImage: CGImage! = bitmapRef?.makeImage()
        return UIImage(cgImage: scaledImage)
    }
    
    /// 改变二维码图片的像素的颜色
    private func cwModifyTintColor(tintColor: UIColor) -> UIImage {
        
        // 必须可以转换为CGImage
        guard let mCgImage = self.cgImage else {
            return self
        }
        
        // 将Float类型保存为Int进行地址操作
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        // 创建一个大小为 4 * width * height 的缓存区
        let bytesPerRow = width * 4
        let byteSize = width * height
        
        // 初始化一个指针类型并分配空间
        let rgbImageBuf = UnsafeMutablePointer<CWPixel>.allocate(capacity: byteSize)
        
        
        // 初始化绘制，颜色空间跟随设备
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        // 用BGRA创建一个位图
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo = bitmapInfo | CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        // 创建位图
        guard let context = CGContext(data: rgbImageBuf,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpaceRef,
                                      bitmapInfo: bitmapInfo)  else {
            return self
        }
        
        // 使用rgbImageBuf 填充 mCgImage
        context.draw(mCgImage, in: CGRect(origin: .zero, size: self.size))
        
        
        // 连续存储的内存集合
        var bufferPointer = UnsafeMutableBufferPointer<CWPixel>(start: rgbImageBuf,
                                                                count: byteSize)
        
        // 释放分配的空间
        //        rgbImageBuf.deallocate()
        
        //获取红绿蓝色值
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // 遍历像素，改变像素点颜色
        for currentPixel in 0..<byteSize {
            var pixel = bufferPointer[currentPixel]
            if !pixel.isWhite {
                //当不是白色的时候才使用
                pixel.red = UInt8(red * 255)
                pixel.green = UInt8(green * 255)
                pixel.blue = UInt8(blue * 255)
                //                pixel.alpha = UInt8(alpha * 255)
                let retPixel = pixel
                bufferPointer[currentPixel] = retPixel
            }
        }
        
        let inputColorSpace = CGColorSpaceCreateDeviceRGB()
        var inputBitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        let inputBytesPerRow = width * 4
        
        inputBitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        guard let imageContext = CGContext(data: bufferPointer.baseAddress,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: 8,
                                           bytesPerRow: inputBytesPerRow,
                                           space: inputColorSpace,
                                           bitmapInfo: inputBitmapInfo,
                                           releaseCallback: nil,
                                           releaseInfo: nil) else {
            return self
        }
        
        guard let cgImage = imageContext.makeImage() else {
            return self
        }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    /// 给二维码图片添加logo
    private func cwAddLogoImage(image: UIImage,
                                frame: CGRect) -> UIImage? {
        var resultImage: UIImage? = nil
        if frame != CGRect.zero {
            // 开始绘制
            UIGraphicsBeginImageContext(self.size)
            //绘制二维码图片
            self.draw(in: CGRect.init(origin: CGPoint.zero,
                                      size:self.size))
            //绘制Logo
            image.draw(in: frame)
            //获取绘制之后的image
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            //结束绘制
            UIGraphicsEndImageContext();
        }
        return resultImage
    }
    
}


public struct CWPixel {
    // 完整像素值
    var value: UInt32
    
    // 红色值
    var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        }
        set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }
    
    // 绿色
    var green: UInt8 {
        get {
            return UInt8((value >> 8) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }
    
    // 蓝色
    var blue: UInt8 {
        get {
            return UInt8((value >> 16) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }
    
    // 透明
    var alpha: UInt8 {
        get {
            return UInt8((value >> 24) & 0xFF)
        }
        set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
    
    // 是否为白色
    var isWhite: Bool {
        get {
            return value == 0xFFFFFFFF
        }
    }
    
}
