//
//  TargetType+Cache.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper

public extension TargetType where Self: Cacheable, Self.ResponseType == Moya.Response {
    
    func onCache<C: Mappable>(
        _ type: C.Type,
        atKeyPath keyPath: String? = nil,
        using decoder: JSONDecoder = .init(),
        _ closure: (C) -> Void)
        -> OnCache<Self, C>
    {
        if let object = try? cachedResponse()
            .mapObject(C.self) {
            closure(object)
        }
        
        return OnCache(target: self, keyPath: keyPath, decoder: decoder)
    }
}

public extension TargetType where Self: Cacheable, Self.ResponseType == Moya.Response {
    
    var cache: Observable<Self> {
        return Observable.just(self)
    }
    
    func cachedResponse() throws -> Moya.Response {
        let response = try cachedResponse(for: cachedKey)
        return Response(statusCode: response.statusCode, data: response.data)
    }
    
    func storeCachedResponse(_ cachedResponse: Moya.Response) throws {
        try storeCachedResponse(cachedResponse, for: cachedKey)
    }
    
    func removeCachedResponse() throws {
        try removeCachedResponse(for: cachedKey)
    }
}
