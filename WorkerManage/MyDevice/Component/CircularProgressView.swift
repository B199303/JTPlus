//
//  CircularProgressView.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/27.
//

import UIKit

class CircularProgressView: UIView {
    
    var progressLayer: CAShapeLayer!
    var clockwise = true
    var lineColor = UIColor.blue
    
    init(clockwise:Bool, lineColor:UIColor){
        super.init(frame: .zero)
        self.clockwise = clockwise
        self.lineColor = lineColor
        setupProgressLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressLayer()
    }
    
    func setupProgressLayer() {
        
        let center = CGPoint(x: 50, y:50 )
        let radius = (50-8)*CGFloat.widthSize() // 减去一些边距
        var startAngle = -CGFloat.pi / 2 // 起始角度
        if !clockwise{
            startAngle = 0
        }
        let endAngle = startAngle + 2 * CGFloat.pi // 结束角度，形成一个完整的圆
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
//        circularPath.lineCapStyle = .round
        progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = lineColor.cgColor // 进度颜色
        progressLayer.lineWidth = 16*CGFloat.widthSize() // 进度线宽
        progressLayer.fillColor = UIColor.clear.cgColor // 不填充颜色
        progressLayer.strokeEnd = 0.75 // 初始进度为0
        progressLayer.lineCap = .round
        
        layer.addSublayer(progressLayer)
    }
    
    func setProgress(progress: CGFloat) {
        progressLayer.strokeEnd = progress // 更新进度
    }
    
}
