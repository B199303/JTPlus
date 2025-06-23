//
//  BaseResponse.swift
//  UnstoppableWallet
//
//  Created by iOS on 2021/7/13.
//  Copyright © 2021 Grouvi. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BaseReponseProtocol: Mappable {
    var code: Int { get }
    var msg: String { get }
}

class EmptyDataResponse: BaseReponseProtocol {
    var msg: String = ""
    var code: Int = -1
    var result: Bool = false
        
    required init?(map: Map) { }
    
    init() { }
    
    func mapping(map: Map) {
        msg <- map["msg"]
        code <- map["code"]
        result <- map["data.result"]
    }
}

class BaseResponse<T: Mappable>: BaseReponseProtocol {
    var data: T?
    var msg: String = ""
    var code: Int = -1
    
    required init?(map: Map) { }
        
    func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
    }
    
    var success: Bool {
        return code == 0
    }
}

class BaseArrayResponse<T: Mappable>: BaseReponseProtocol {
    var data: ArrayResponse<T>?
    var msg: String = ""
    var code: Int = 0
    
    required init?(map: Map) {
    }
    
    var success: Bool {
        return code == 0
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        msg <- map["msg"]
        code <- map["code"]
    }
}

class ArrayResponse<T: Mappable>: Mappable {
    var list: [T] = []
    var size: Int = 0
    var page: Int = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        list <- map["list"]
        size <- map["size"]
        page <- map["page"]
    }
}
