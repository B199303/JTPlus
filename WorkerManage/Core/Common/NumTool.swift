//
//  NumTool.swift
//  WorkerManage
//
//  Created by BL L on 2022/10/22.
//

import UIKit

class ValueFormatter {
    static let instance = ValueFormatter()
    
    private let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    func format(decimalNum:Decimal ,maximumFractionDigits:Int? = nil, roundingMode: NumberFormatter.RoundingMode? = .down) -> String? {

        let formatter = percentFormatter
        if let r = roundingMode{
            formatter.roundingMode = r
        }
        if let m = maximumFractionDigits{
            formatter.maximumFractionDigits = m
        }
        return formatter.string(from: decimalNum as NSNumber)
    }
}

class NumTool: NSObject {
    public static func numberAsPercentage(_ number: String) -> String {
        if number.count > 0 {
            let numStr = NumTool.remainDecimal(numberString: number, num: 2)
            guard let decimalNum = Decimal(string: numStr) else {return ""}
            let endNum = decimalNum*100
            guard let str = ValueFormatter.instance.format(decimalNum: endNum, maximumFractionDigits: 4) else {return ""}
            return str + "%"
        }else{
            return ""
        }
    }
    
    public static func remainDecimal(numberString:String, num:Int) -> String{
        if numberString.count > 0 {
            guard let decimalNum = Decimal(string: numberString) else {return ""}
            guard let str = ValueFormatter.instance.format(decimalNum: decimalNum, maximumFractionDigits: num, roundingMode: .down) else {return ""}
            return str
        }else{
            return ""
        }
    }
}
