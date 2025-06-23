//
//  DeviceApi.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/11.
//

import Moya
import Foundation
import Alamofire


enum DeviceApi{
    case getProductListByUser(userId:Int)
    case getDeviceList(productId:Int)
    case getProductMetrics(productId:Int)
    case getDeviceMetrics(deviceId:Int)
    case getDeviceDetail(deviceId:Int)
    case getDeviceAlarmStatic(deviceId:Int, startTime:String? = nil, endTime: String? = nil)
    case changeDeviceMessage(deviceId:Int, deviceName:String, deviceLocation:String)
    case unBindDevice(deviceId:Int)
    case bindDevice(deviceIdentify:String, productIdentify:String, qrCodeKey:String)
    case alarmList(limit:Int, page:Int, startTime:String? = nil, endTime:String? = nil)
}

extension DeviceApi:TargetType{
    var baseURL: URL {
        return URL(string: "\(App.shared.appConfigProvider.domain)/jt-home-api/")!
    }
    
    var path: String {
        switch self{
        case .getDeviceList:
            return "business/device/list"
        case .getProductListByUser:
            return "business/product/listByUser"
        case .getDeviceMetrics:
            return "business/deviceMetrics/metricsByDevice"
        case .getProductMetrics:
            return "business/deviceMetrics/metricsByProduct"
        case .getDeviceDetail:
            return "business/device/detail"
        case .getDeviceAlarmStatic:
            return "business/deviceAlarm/alarmStatistics"
        case .changeDeviceMessage:
            return "business/clientUserDeviceInfo/update"
        case .unBindDevice:
            return "business/device/unbind"
        case .bindDevice:
            return "business/device/bind"
        case .alarmList:
            return "business/deviceAlarm/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDeviceList, .getProductListByUser, .getDeviceMetrics, .getProductMetrics, .getDeviceDetail, .getDeviceAlarmStatic, .changeDeviceMessage, .unBindDevice, .bindDevice, .alarmList:
            return .post
        }
    }
    
    public var parameters: [String: Any] {
        switch self{
        case let .getDeviceList(productId):
            return ["productId" : productId]
        case let .getProductMetrics(productId):
            return ["productId" : productId]
        case let .getDeviceMetrics(deviceId):
            return ["deviceId" : deviceId]
        case let .getProductListByUser(userId):
            return ["userId" : userId]
        case let .getDeviceDetail(deviceId):
            return ["deviceId" : deviceId]
        case let .getDeviceAlarmStatic(deviceId, startTime, endTime):
            var params: [String:Any] = ["deviceId" : deviceId]
            if startTime != nil{
                params["startTime"] = startTime
            }
            if endTime != nil{
                params["endTime"] = endTime
            }
            return params
        case let .changeDeviceMessage(deviceId, deviceName, deviceLocation):
            return ["deviceId" : deviceId, "deviceName" : deviceName, "deviceLocation" : deviceLocation]
        case let .unBindDevice(deviceId):
            return ["deviceId" : deviceId]
        case let .bindDevice(deviceIdentify, productIdentify, qrCodeKey):
            return ["deviceIdentify" : deviceIdentify, "productIdentify" : productIdentify, "qrCodeKey" : qrCodeKey]
        case let .alarmList(limit, page, startTime, endTime):
            var params: [String: Any] = ["limit" : limit, "page" : page]
            let sTime = " 00:00:00"
            let eTime = " 23:59:50"
            if endTime != nil && endTime != "" {
                params["endTime"] = (endTime ?? "") + eTime
            }
            if startTime != nil && startTime != "" {
                params["startTime"] = (startTime ?? "") + sTime
            }
            return params
        }
    }
    
    var task: Moya.Task {
        switch self{
        case .getDeviceList, .getProductListByUser, .getDeviceMetrics, .getProductMetrics, .getDeviceDetail, .getDeviceAlarmStatic, .changeDeviceMessage, .unBindDevice, .bindDevice, .alarmList:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getDeviceList, .getProductListByUser, .getDeviceMetrics, .getProductMetrics, .getDeviceDetail, .getDeviceAlarmStatic, .changeDeviceMessage, .unBindDevice, .bindDevice, .alarmList:
            return Network.sharedHeaders()
        default:
            return [:]
        }
    }
    
    
}
