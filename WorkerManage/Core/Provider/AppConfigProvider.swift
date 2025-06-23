//
//  AppConfigProvider.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/8.
//

import Foundation

class AppConfigProvider: IAppConfigProvider {
    let companyWebPageLink = ""
    let appWebPageLink = ""
    let reportEmail = ""
    
    var h5domain: String {
        return domain.replacingOccurrences(of: "app", with: "website")
    }
    
    var domain: String {
        let dev = "http://192.168.172.180:9527"
//        let dev = "http://192.168.31.5:7281"
        let uat = "http://192.168.172.180:9527"
        return isUAT ? uat : dev
    }
    
    var baseURL: String {
        let dev = "http://192.168.172.180:9527/jt-home-api"
//        let dev = "http://192.168.31.5:7281/thermal-api"
        let uat = "http://192.168.172.180:9527/jt-home-api"
        return isUAT ? uat : dev
    }
    
    var shareURL: String {
        let dev = "http://192.168.172.228:9527"
        let uat = "http://183.62.149.43:9527"
        return isUAT ? uat : dev
    }
    
    let isUAT: Bool = false
    
    var version:String = "1.0.0"
    
}
