//
//  NetModel.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/22.
//

import UIKit
import ObjectMapper

class NetModel: NSObject {

}

public class SourceData: Mappable{
    var msg: String = ""
    var code: Int = 0
    var total: Int = 0
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
    }
    
    func checkCode(code:Int){
        if code == 10000{ //多人登录
            NotificationCenter.default.post(name: Notification.Name("backToLogin"),
                                            object: nil,
                                            userInfo: nil)
        }else if code == 10001{//过期
            NotificationCenter.default.post(name: Notification.Name("refreshToken"),
                                            object: nil,
                                            userInfo: nil)
        }else if code == 10011{//账户不存在
            NotificationCenter.default.post(name: Notification.Name("backToLogin"),
                                            object: nil,
                                            userInfo: nil)
        }else if code == 10012{//账号已被冻结
            NotificationCenter.default.post(name: Notification.Name("backToLogin"),
                                            object: nil,
                                            userInfo: nil)
        }
    }
}

public class GetRsaKey: SourceData {
    var data: String = ""
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class LoginResult: SourceData {
    var data: String = ""
    
    required public init?(map: Map) {  super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}

public class UserInfo: SourceData {
    var data: UserInfoData?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        self.checkCode(code: code)
    }
}

public class UserInfoData: Mappable {
    var id: Int = 0
    var account: String = ""
    var name: String = ""
    var avatar: String = ""
    var sex: Int = 0
    var totalDeviceCount: Int = 0
    var region: String = ""
    
    var phone: String = ""
    var email: String = ""
    var createTime: String = ""
    
    required public init?(map: Map) { }
    
    init(id:Int, account:String, name:String, avatar:String, sex:Int, totalDeviceCount:Int, region:String) {
        self.id = id
        self.account = account
        self.name = name
        self.avatar = avatar
        self.sex = sex
        self.totalDeviceCount = totalDeviceCount
        self.region = region
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
        account <- map["account"]
        name <- map["name"]
        avatar <- map["avatar"]
        phone <- map["phone"]
        sex <- map["sex"]
        email <- map["email"]
        createTime <- map["createTime"]
        
        totalDeviceCount <- map["totalDeviceCount"]
        region <- map["region"]
    }
}

public class AlarmListData: SourceData {
    var data: [AlarmListContent] = []
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        self.checkCode(code: code)
    }
}

public class AlarmListContent: Mappable {
    var deviceModel: String = ""
    var deviceNumber: String = ""
    var msg: String = ""
    var alarmTime: String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        deviceModel <- map["deviceModel"]
        deviceNumber <- map["deviceNumber"]
        msg <- map["msg"]
        alarmTime <- map["alarmTime"]
    }
}

public class mqttWarn: Mappable {
    var sequenceId: String = ""
    var version: String = ""
    var time: String = ""
    var messageType: Int = 0
    var deviceModel: String = ""
    var deviceNumber: String = ""
    var data: mqttWarnData?
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        sequenceId <- map["sequenceId"]
        version <- map["version"]
        time <- map["time"]
        messageType <- map["messageType"]
        deviceModel <- map["deviceModel"]
        deviceNumber <- map["deviceNumber"]
        data <- map["data"]
    }
}

public class mqttWarnData: Mappable {
    var msg: String = ""
    var alarmTime: String = ""
    var open: Bool = true
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        msg <- map["msg"]
        alarmTime <- map["alarmTime"]
        open <- map["open"]
    }
}


public class CheckVersion: SourceData {
    var data: CheckVersionData?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        self.checkCode(code: code)
    }
}

public class CheckVersionData: Mappable {
    var id: Int = 0
    var appName: String = ""
    var versionCode: String = ""
    var downloadUrl: String = ""
    var forceUpdate: Int = 0
    var createTime: String = ""
    var updateTime: String = ""
    var versionInfo:[CheckVersionDataInfo] = []
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        id <- map["id"]
        appName <- map["appName"]
        versionCode <- map["versionCode"]
        downloadUrl <- map["downloadUrl"]
        updateTime <- map["updateTime"]
        forceUpdate <- map["forceUpdate"]
        createTime <- map["createTime"]
        versionInfo <- map["versionInfo"]
    }
}


public class CheckVersionDataInfo: Mappable {
    var type: String = ""
    var desc: String = ""
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        type <- map["type"]
        desc <- map["desc"]
    }
}

public class VersionHistory: SourceData {
    var data: [CheckVersionData] = []
    
    required public init?(map: Map) { super.init(map: map)}
    
    public override func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
        total <- map["total"]
        
        self.checkCode(code: code)
    }
}
