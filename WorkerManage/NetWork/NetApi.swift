//
//  NetApi.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/4.
//

import Moya
import Foundation
import Alamofire

enum NetAPI{
    case getEntrypt
    case login(account:String, pwd:String)
    case userInfo(userId:Int? = nil)
    case alarmList(limit:Int, page:Int, query:String? = nil, startTime:String? = nil, endTime:String? = nil)
    case updateClientUserInfo(name:String? = nil, avatar:String? = nil, sex:Int? = nil, password:String? = nil, newPassword:String? = nil)
    case loginOut
    case uploadImage(data:Data, fileName:String)
    case checkVersion
    case versionHistory(type:Int)
}

extension NetAPI:TargetType {
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var baseURL: URL {
        return URL(string: "\(App.shared.appConfigProvider.domain)/jt-home-api/")!
    }
    
    var path: String {
        switch self {
        case .getEntrypt:
            return "base/encrypt/pk"
        case .login:
            return "client/clientUserInfo/login"
        case .userInfo:
            return "client/clientUserInfo/detail"
        case .alarmList:
            return "device/alarm/list"
        case .updateClientUserInfo:
            return "client/clientUserInfo/update"
        case .loginOut:
            return "client/clientUserInfo/logout"
        case .uploadImage:
            return "base/oss/upload"
        case .checkVersion:
            return "business/appVersion/checkForUpdate"
        case .versionHistory:
            return "business/appVersion/history"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEntrypt:
            return .get
        case .login, .userInfo, .alarmList, .updateClientUserInfo, .loginOut, .uploadImage, .checkVersion, .versionHistory:
            return .post
        }
    }
    
    public var parameters: [String: Any] {
        switch self{
        case .getEntrypt:
            return [:]
        case let .login(account, pwd):
            return ["account":account, "pwd": pwd]
        case let .userInfo(userId):
            var params: [String:Any] = [:]
            if userId != nil{
                params["userId"] = userId
            }
            return params
        case let .alarmList(limit, page, query, startTime, endTime):
            var params: [String: Any] = ["limit":limit, "page": page]
            if query != nil{
                params["query"] = query
            }
            let start = " 00:00:00"
            let end = " 23:59:59"
            if startTime != nil && startTime != "" {
                params["startTime"] = (startTime ?? "") + start
            }
            if endTime != nil && endTime != ""  {
                params["endTime"] = (endTime ?? "") + end
            }
            return params
        case let .updateClientUserInfo(name, avatar, sex, password, newPassword):
            var params: [String: Any] = [:]
            if name != nil{
                params["name"] = name
            }
            if avatar != nil{
                params["avatar"] = avatar
            }
            if sex != nil{
                params["sex"] = sex
            }
            if password != nil{
                params["password"] = password
            }
            if newPassword != nil{
                params["newPassword"] = newPassword
            }
            return params
        case .loginOut:
            return [:]
        case .uploadImage:
            return [:]
        case .checkVersion:
            return [:]
        case let .versionHistory(type):
            return ["type" : type]
        }
    }
    
    public var task: Task {
        switch self {
        case .getEntrypt:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .uploadImage(data, fileName):
            let formData = MultipartFormData(provider: .data(data), name: "file",
                                                          fileName: fileName, mimeType: "image/png")
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
        default:
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .userInfo, .alarmList, .login, .updateClientUserInfo, .loginOut, .uploadImage, .checkVersion, .versionHistory:
            return Network.sharedHeaders()
        default:
            return [:]
        }
    }
    
}

struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()

        guard let json = parameters?["jsonArray"] else {
            return request
        }

        let data = try JSONSerialization.data(withJSONObject: json, options: [])

        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.httpBody = data

        return request
    }
}
