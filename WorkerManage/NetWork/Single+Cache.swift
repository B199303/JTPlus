//
//  Single+Cache.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    public func storeCachedResponse<Target>(for target: Target) -> Single<Element> where Target: TargetType, Target: Cacheable, Target.ResponseType == Element {
        return map { response -> Element in
            if target.allowStorage(response) {
                try? target.storeCachedResponse(response)
            }
            
            return response
        }
    }
}
