//
//  DateTool.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/12.
//

import UIKit
import RxSwift

enum TimeFormat:String{
    case MMDD = "MM月dd日"
    case YYYYMM = "YYYY年MM月"
    case YYYYMMDD = "YYYY-MM-dd"
    case YYYYmmdd = "YYYY年MM月dd日"
    case YYYYMMDDHH = "YYYY-MM-dd HH"
    case YYYYMMDDHHMM = "YYYY-MM-dd HH:mm"
    case YYYYMMDDHHMMSS = "YYYY-MM-dd HH:mm:ss"
    case HHMMSS = "HH:mm:ss"
}

class DateTool: NSObject {
    //获取当前时间
    public static func getCurrentTime(timeFormat:TimeFormat) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        let timeZone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timeZone
        let dateTime = formatter.string(from: Date.init())
        return dateTime
    }
    
    //字符串转时间戳
    public static func timeToTimestamp(timeFormat:TimeFormat, timeString:String) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = timeFormat.rawValue
        let timeZone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timeZone
        let dateTime = formatter.date(from: timeString)
        return String(dateTime!.timeIntervalSince1970)
    }
    
    //时间戳转字符串
    public static func timestampToString(timeFormat:TimeFormat, timestamp:Int) -> String{
        let string = String(timestamp/1000)
        let stamp:TimeInterval = Double(string) ?? 0
        let date = NSDate(timeIntervalSince1970: stamp)
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        return formatter.string(from: date as Date)
    }
    
    //Date类型转成字符串
    public static func stringFromDate(timeFormat:TimeFormat,date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        let timeZone = TimeZone.init(identifier: "Asia/Beijing")
        formatter.timeZone = timeZone
        let dateTime = formatter.string(from: date)
        return dateTime
    }
    
    //字符串转成Date类型
    public static func dateFromString(timeFormat:TimeFormat,date:String) -> NSDate{
        let formatter = DateFormatter()
        formatter.locale = NSLocale.init(localeIdentifier: "en_US") as Locale
        formatter.dateFormat = timeFormat.rawValue
        guard let inputDate = formatter.date(from: date) else {return NSDate()}
        let zone = NSTimeZone.system
        let interVal = zone.secondsFromGMT(for: inputDate)
        let localeDate = inputDate.addingTimeInterval(TimeInterval(interVal))
        return localeDate as NSDate
    }
    
    //上一天
    public static func getLastDay(timeFormat:TimeFormat,dateString:String) -> String{
        let lastDay = NSDate.init(timeInterval: -24*60*60, since: dateFromString(timeFormat: timeFormat, date: dateString)as Date )
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        let strDate = formatter.string(from: lastDay as Date)
        return strDate
    }
    
    //上n天
    public static func getDaysBefore(num:Int,timeFormat:TimeFormat,dateString:String) -> String{
        let lastDay = NSDate.init(timeInterval: -24*60*60*Double(num), since: dateFromString(timeFormat: timeFormat, date: dateString)as Date )
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        let strDate = formatter.string(from: lastDay as Date)
        return strDate
    }
    
    public static func getDaysAfter(num:Int,timeFormat:TimeFormat,dateString:String) -> String{
        let lastDay = NSDate.init(timeInterval: 24*60*60*Double(num), since: dateFromString(timeFormat: timeFormat, date: dateString)as Date )
        let formatter = DateFormatter()
        formatter.dateFormat = timeFormat.rawValue
        let strDate = formatter.string(from: lastDay as Date)
        return strDate
    }
    
    //比较两天前后 true为正序，false为逆序
    public static func compare(start:String,end:String, formatStr:String? = nil) -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        if let formatStr = formatStr{
            formatter.dateFormat = formatStr
        }
        if let startTime = formatter.date(from: start), let stopTime = formatter.date(from: end){
            let intervalStart = startTime.timeIntervalSince1970
            let intervalStop = stopTime.timeIntervalSince1970
            if intervalStart < intervalStop{
                return true
            }else{
                return false
            }
        }
        
        return false
    }
    
    //上周或本周
    public static func getWeeksDate(isLast:Bool, dateString:String) -> String {
        //当前时间
        var currentDate = Date()
        if isLast{
            currentDate = NSDate.init(timeInterval: -24*60*60*7, since: dateFromString(timeFormat: TimeFormat.YYYYMMDD, date: dateString)as Date) as Date
        }
        let calender = Calendar.current
        var comp = calender.dateComponents([.year, .month, .day, .weekday], from: currentDate)
        
        //当前时间是几号、周几
        let currentDay = comp.day
        let weeKDay = comp.weekday
        
        //如果获取当前时间的日期和周几失败，返回nil
        guard let day = currentDay, let week = weeKDay else {
            return ""
        }
        
        //由于1代表的是周日，因此计算出准确的周几
        var currentWeekDay = 0
        if week == 1 {
            currentWeekDay = 7
        } else {
            currentWeekDay = week - 1
        }
        
        //1 ... 7表示周一到周日
        //进行遍历和currentWeekDay进行比较，计算出之间的差值，即为当前日期和一周时间日期的差值，即可计算出一周时间内准备的日期
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let fromDiff = 1 - currentWeekDay
        comp.day = day + fromDiff
        guard let fromDate = calender.date(from: comp) else {return ""}
        let fromStr = formatter.string(from: fromDate as Date)
        
        let toDiff = 7 - currentWeekDay
        comp.day = day + toDiff
        guard let toDate = calender.date(from: comp) else {return ""}
        let toStr = formatter.string(from: toDate as Date)
        //返回时间数组
        return "\(fromStr) \(toStr)"
    }
    
    //上月或本月
    public static func getThisMonthDate(isLast: Bool, data:Date? = nil) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = Date()
        if let d = data {
            date = d
        }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: date)
        guard let startOfMonth = calendar.date(from: components) else {return ""}
        
        let fromStr = dateFormatter.string(from: startOfMonth)
        components.year = 0
        components.month = 1
        components.day = -1
        guard let endOfMonth =  calendar.date(byAdding: components, to: startOfMonth) else {return ""}
        let toStr = dateFormatter.string(from: endOfMonth as Date)
        
        components.year = 0
        components.month = 0
        guard let lastMonth =  calendar.date(byAdding: components, to: startOfMonth) else {return ""}
        let lastStr = dateFormatter.string(from: lastMonth as Date)
        let lastArr = lastStr.components(separatedBy: "-")
        var lastStart = ""
        if lastArr.count == 3{
            lastStart = "\(lastArr[0])-\(lastArr[1])-01"
        }
        if isLast{
            return "\(lastStart) \(lastStr)"
        }else{
            return "\(fromStr) \(toStr)"
        }
    }
    
    public static func getNextMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let calendar = Calendar.current
        
        // 当前传入日期 转成 DateComponents 格式
        var currentComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        // 设置为 1，转成 Date 后为当前传入日期月份的第一天
        currentComponents.day = 1
        
        if let startOfMonth = calendar.date(from: currentComponents) {
            
            // 处理时间差
            var diffComponents = DateComponents()
            // 添加一个月的时间差
            diffComponents.month = 1
            
            // 下个月第一天
            if let startDate = calendar.date(byAdding: diffComponents, to: startOfMonth) {
                let startDayString = dateFormatter.string(from: startDate)
                
                // 和当前月第一天相差两个月少一天即为下个月最后一天时间
                diffComponents.month = 2
                diffComponents.day = -1
                if let endDate = calendar.date(byAdding: diffComponents, to: startOfMonth) {
                    let endDayString = dateFormatter.string(from: endDate)
                    return "\(startDayString) \(endDayString)"
                }
            }
        }
        return ""
    }
    
    
    
    //这个月天数
    public static func getThisMonthDays() -> Int{
        let calendar = Calendar.current
        let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: Date())
        return range!.count
    }
    
    //转农历
    public static func getLunarDayFrom(dateString:String) -> String {
        let date = dateFromString(timeFormat: .YYYYMMDDHHMMSS, date: dateString)
        
        let calendar = Calendar.init(identifier: .chinese)
        //        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = calendar
        return formatter.string(from: date as Date)
    }
    
    //从今天开始几天后
    public static func getDayWith(dateStr: String, num:Int) -> String{
        let date = dateFromString(timeFormat: .YYYYMMDD, date: dateStr)
        let second = 24*60*60
        let appointDate = date.addingTimeInterval(Double(second*num))
        let formatter = DateFormatter()
        formatter.dateFormat = TimeFormat.YYYYMMDD.rawValue
        let strDate = formatter.string(from: appointDate as Date)
        return strDate
    }
    
    //两个时间差值
    public static func getTimeBetween(time1:String, time2:String, timeFormat:TimeFormat) -> String{
        let date1 = dateFromString(timeFormat: timeFormat, date: time1)
        let date2 = dateFromString(timeFormat: timeFormat, date: time2)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1 as Date, to: date2 as Date)
        var endStr = ""
        if let date = components.day{
            if String(date) != "0"{
                endStr = String(date) + "天"
            }
        }
        if let hour = components.hour{
            if String(hour) != "0"{
                endStr = endStr + String(hour) + "小时"
            }
        }
        if let minute = components.minute{
            if String(minute) != "0"{
                endStr = endStr + String(minute) + "分钟"
            }
        }
        if let second = components.second{
            if String(second) != "0"{
                endStr = endStr + String(second) + "秒"
            }
        }
        return endStr
    }
    
    //根据日期获取周几
    public static func getWeekWith(dateString:String) -> String{
        let date = dateFromString(timeFormat: .YYYYMMDD, date: dateString)
        let interVal = Int(date.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()
        let days = Int(interVal/86400)
        let weekday = ((days + 4)%7 + 7)%7
        let comps = weekday == 0 ? 7 : weekday
        var str = ""
        if comps == 1{str = "一"}
        else if comps == 2{str = "二"}
        else if comps == 3{str = "三"}
        else if comps == 4{str = "四"}
        else if comps == 5{str = "五"}
        else if comps == 6{str = "六"}
        else if comps == 7{str = "日"}
        return str
    }
    
    public static func getDateArrBetween(dayStr1:String, dayStr2:String) -> [String]{
        let date1 = self.dateFromString(timeFormat: .YYYYMMDD, date: dayStr1)
        let date2 = self.dateFromString(timeFormat: .YYYYMMDD, date: dayStr2)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1 as Date, to: date2 as Date) //数组里按具体年月日算出间隔
        var daysArr:[String] = []
        
        for i in 0 ..< (components.day ?? 0) + 1{
            let interval = 24*60*60
            let date = NSDate.init(timeInterval: TimeInterval(interval*i), since: date1 as Date)
            let dayStr = self.stringFromDate(timeFormat: .YYYYMMDD, date: date as Date)
            daysArr.append("\(dayStr) 00:00:00")
        }
        return daysArr
    }
    
    public static func getWeekRange() -> (start: String, end: String)? {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 设置一周的第一天为周一
        
        // 获取当前日期
        let today = Date()
        
        // 获取当前周的开始日期（周一）
        guard let firstDayOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else { return nil }
        
        // 获取当前周的结束日期（周日）
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek) else { return nil }
        
        return (start: self.stringFromDate(timeFormat: .YYYYMMDD, date: firstDayOfWeek as Date), end: self.stringFromDate(timeFormat: .YYYYMMDD, date: endOfWeek as Date))
    }
}


open class LunarFormatter: NSObject {
    
    fileprivate let chineseCalendar = Calendar(identifier: .chinese)
    fileprivate let formatter = DateFormatter()
    fileprivate let lunarDays = ["初二","初三","初四","初五","初六","初七","初八","初九","初十","十一","十二","十三","十四","十五","十六","十七","十八","十九","二十","二一","二二","二三","二四","二五","二六","二七","二八","二九","三十"]
    fileprivate let lunarMonths = ["正月","二月","三月","四月","五月","六月","七月","八月","九月","十月","冬月","腊月"]
    
    
    override init() {
        self.formatter.calendar = self.chineseCalendar
        self.formatter.dateFormat = "M"
    }
    
    open func string(from date: Date) -> String {
        let day = self.chineseCalendar.component(.day, from: date)
        if day != 1 {
            return self.lunarDays[day-2]
        }
        // First day of month
        let monthString = self.formatter.string(from: date)
        if self.chineseCalendar.veryShortMonthSymbols.contains(monthString) {
            if let month = Int(monthString) {
                return self.lunarMonths[month-1]
            }
            return ""
        }
        // Leap month
        let month = self.chineseCalendar.component(.month, from: date)
        return "闰" + self.lunarMonths[month-1]
    }

    
}
