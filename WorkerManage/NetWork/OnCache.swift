//
//  OnCache.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper

public struct OnCache<Target: TargetType, C: Mappable> where Target: Cacheable, Target.ResponseType == Moya.Response {
    public let target: Target
    
    private let keyPath: String?
    
    private let decoder: JSONDecoder
    
    public init(target: Target, keyPath: String?, decoder: JSONDecoder) {
        self.target = target
        self.keyPath = keyPath
        self.decoder = decoder
    }
    
    public func request() -> Single<C> {
        return target.request()
        .storeCachedResponse(for: target)
        .mapObject(C.self)
    }
}
