//
//  DeviceModels.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/11.
//

import UIKit
import ObjectMapper

class DeviceModels: NSObject {

}

public class DeviceList: SourceData {
    var data: [DeviceListData] = []
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class DeviceListData: Mappable {
    var id: Int = 0
    var productId:Int = 0
    var identify:String = ""
    var deviceCoverImage:String = ""
    var name:String = ""
    var description:String = ""
    var online:Bool = false
    var deviceEncoding:String = ""
    var deviceLocation:String = ""
    var status:Int = 0
    var runDuration:Int = 0
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
        productId <- map["productId"]
        identify <- map["identify"]
        deviceCoverImage <- map["deviceCoverImage"]
        name <- map["name"]
        description <- map["description"]
        online <- map["online"]
        deviceEncoding <- map["deviceEncoding"]
        deviceLocation <- map["deviceLocation"]
        status <- map["status"]
        runDuration <- map["runDuration"]
    }
}


public class ProductList: SourceData {
    var data: [ProductListData] = []
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class ProductListData: Mappable {
    var productId:Int = 0
    var productIdentify:String = ""
    var productName:String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        productId <- map["productId"]
        productIdentify <- map["productIdentify"]
        productName <- map["productName"]
    }
}

public class DeviceMetrics: SourceData {
    var data: DeviceMetricsData?
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class DeviceMetricsData: Mappable {
    var todayMetrics:DeviceMetricsContentData?
    var curWeekMetrics:DeviceMetricsContentData?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        todayMetrics <- map["todayMetrics"]
        curWeekMetrics <- map["curWeekMetrics"]
    }
}

public class DeviceMetricsContentData: Mappable {
    var capacity:Float = 0
    var nitrogenConsumption:Float = 0
    var powerConsumption:Float = 0
    var runDuration:Int = 0
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        capacity <- map["capacity"]
        nitrogenConsumption <- map["nitrogenConsumption"]
        powerConsumption <- map["powerConsumption"]
        runDuration <- map["runDuration"]
    }
}


public class DeviceDetail: SourceData {
    var data: DeviceDetailData?
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class DeviceDetailData: Mappable {
    var deviceId: Int = 0
    var totalAlarmCount:Int = 0
    var deviceLocation:String = ""
    var deviceName:String = ""
    var deviceCoverImage:String = ""
    var deviceEncoding:String = ""
    var deviceModel:String = ""
    var manufactureDate:String = ""
    var recentlyAlarmInfo: DeviceDetailDataInfo?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        deviceId <- map["deviceId"]
        totalAlarmCount <- map["totalAlarmCount"]
        deviceLocation <- map["deviceLocation"]
        deviceName <- map["deviceName"]
        deviceCoverImage <- map["deviceCoverImage"]
        deviceEncoding <- map["deviceEncoding"]
        deviceModel <- map["deviceModel"]
        manufactureDate <- map["manufactureDate"]
        recentlyAlarmInfo <- map["recentlyAlarmInfo"]
    }
}

public class DeviceDetailDataInfo: Mappable {
    var alarmTime:String = ""
    var alarmContent:String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        alarmTime <- map["alarmTime"]
        alarmContent <- map["alarmContent"]
    }
}

public class DeviceAlarmStatic: SourceData {
    var data: [DeviceAlarmStaticData] = []
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class DeviceAlarmStaticData: Mappable {
    var alarmCount:Int = 0
    var alarmTime:String = ""
    var showTime:String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        alarmCount <- map["alarmCount"]
        alarmTime <- map["alarmTime"]
        self.changeTime(alarmTime: alarmTime)
    }
    
    init(alarmCount:Int, showTime:String){
        self.alarmCount = alarmCount
        self.showTime = showTime
    }
    
    func changeTime(alarmTime:String){
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd HH:mm:ss" // 设置原始日期的格式
        dateFormatterInput.locale = Locale(identifier: "en_US_POSIX") // 使用固定区域设置避免解析问题
         
        // 将字符串转换为Date对象
        if let date = dateFormatterInput.date(from: alarmTime) {
            // 创建另一个DateFormatter对象用于格式化日期为月日格式
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.dateFormat = "MM/dd" // 设置目标日期格式为月日
            dateFormatterOutput.locale = Locale(identifier: "en_US_POSIX") // 使用固定区域设置避免格式化问题
            
            // 将Date对象转换为月日格式的字符串
            let formattedDateString = dateFormatterOutput.string(from: date)
            self.showTime = formattedDateString
        } else {
            print("日期格式不正确")
        }
    }
}

public class DeviceAlarmList: SourceData {
    var data: [DeviceAlarmListData] = []
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class DeviceAlarmListData: Mappable {
    var deviceId:Int = 0
    var deviceCoverImage:String = ""
    var deviceName:String = ""
    var deviceLocation:String = ""
    var alarmTime:String = ""
    var alarmContent:String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        deviceId <- map["deviceId"]
        deviceCoverImage <- map["deviceCoverImage"]
        deviceName <- map["deviceName"]
        deviceLocation <- map["deviceLocation"]
        alarmTime <- map["alarmTime"]
        alarmContent <- map["alarmContent"]
    }
}


public class ScanResultData: Mappable {
    var productIdentify: String = ""
    var deviceIdentify: String = ""
    
    required public init?(map: Map) { }
    
    init(productIdentify:String, deviceIdentify:String) {
        self.productIdentify = productIdentify
        self.deviceIdentify = deviceIdentify
    }
    
    public func mapping(map: Map) {
        productIdentify <- map["productIdentify"]
        deviceIdentify <- map["deviceIdentify"]
    }
}

public class SocketMessageData: Mappable {
    var alarmTime: String = ""
    var deviceEncoding: String = ""
    var deviceId: Int = 0
    var message: String = ""
    
    required public init?(map: Map) { }
    
    init(alarmTime:String, deviceEncoding:String) {
        self.alarmTime = alarmTime
        self.deviceEncoding = deviceEncoding
    }
    
    public func mapping(map: Map) {
        alarmTime <- map["alarmTime"]
        deviceEncoding <- map["deviceEncoding"]
        deviceId <- map["deviceId"]
        message <- map["message"]
    }
}
