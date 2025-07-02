//
//  MyDeviceDetailBarCell.swift
//  WorkerManage
//
//  Created by BL L on 2025/5/28.
//

import UIKit
import Charts

class MyDeviceDetailBarCell: UITableViewCell {
    let bgView = UIView()
    
    let chartView = BarChartView()
    let numLabel = UILabel()
    var data : [DeviceAlarmStaticData] = []
//    [DeviceAlarmStaticData(alarmCount: 5, showTime: "04/09"),
//                                          DeviceAlarmStaticData(alarmCount: 7, showTime: "04/10"),
//                                          DeviceAlarmStaticData(alarmCount: 8, showTime: "04/11"),
//                                          DeviceAlarmStaticData(alarmCount: 4, showTime: "04/12"),
//                                          DeviceAlarmStaticData(alarmCount: 6, showTime: "04/13"),
//                                          DeviceAlarmStaticData(alarmCount: 3, showTime: "04/14"),
//                                          DeviceAlarmStaticData(alarmCount: 1, showTime: "04/15")]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        initUI()
    }
    
    func bind(data:[DeviceAlarmStaticData]){
        self.data = data
        var totalCount = 0
        for item in data{
            totalCount = totalCount + item.alarmCount
        }
        self.numLabel.text = "累计告警次数：\(totalCount)"
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.gridBackgroundColor = .cyan
        chartView.borderColor = .clear
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        
        chartView.maxVisibleCount = 60
        
        let x = chartView.xAxis
        x.labelPosition = .bottom
        x.labelFont = .systemFont(ofSize: 10)
        x.granularity = 1
        x.labelCount = 6
        x.gridColor = .clear
        let dateArr = self.data.map{$0.showTime}
        x.valueFormatter = DayAxisValueFormatter(chart: chartView, strArr: dateArr)
        
        let l = chartView.legend
        l.form = .empty

        let marker = XYMarkerView(color: UIColor.blackColor_60,
                                  font: .systemFont(ofSize: 12),
                                  textColor: .white,
                                  insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                  xAxisValueFormatter: chartView.xAxis.valueFormatter!)
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        self.setDataCount(6)
    }
    
    func initUI(){
        bgView.backgroundColor = .whiteColor
        bgView.cornerRadius = 8*CGFloat.widthSize()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20*CGFloat.widthSize())
            $0.top.equalToSuperview().offset(16*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-16*CGFloat.widthSize())
            $0.height.equalTo(188*CGFloat.widthSize())
        }
        
        numLabel.textAlignment = .right
        numLabel.font = .textFont_12_medium
        numLabel.textColor = .blackColor22
        numLabel.text = "累计告警次数：10000"
        bgView.addSubview(numLabel)
        numLabel.snp.makeConstraints{
            $0.trailing.bottom.equalToSuperview().inset(10*CGFloat.widthSize())
        }
        
        
        bgView.addSubview(chartView)
        chartView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30*CGFloat.widthSize())
            $0.bottom.equalToSuperview().offset(-20*CGFloat.widthSize())
            $0.leading.trailing.equalToSuperview()
        }
        chartView.chartDescription.enabled = false
                
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        
    }
    
    func setDataCount(_ count: Int) {
        
        let yVals = (1 ..< data.count + 1).map { (i) -> BarChartDataEntry in
            let val = Double(data[i-1].alarmCount)
            return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "")
            set1.colors = [UIColor.blueColor68]
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 22)!)
            data.barWidth = 0.5
            chartView.data = data
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



public class DayAxisValueFormatter: NSObject, AxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    var strArr : [String] = []
    
    init(chart: BarLineChartViewBase, strArr:[String]) {
        self.chart = chart
        self.strArr = strArr
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return strArr[Int(value) - 1]
    }
}

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: AxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: AxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = "\(xAxisValueFormatter.stringForValue(entry.x, axis: XAxis()))告警\(NSNumber(integerLiteral: Int(entry.y)))次"
        setLabel(string)
    }
    
}

open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()

        context.setFillColor(color.cgColor)

        if offset.y > 0
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.fillPath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }
    
    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
