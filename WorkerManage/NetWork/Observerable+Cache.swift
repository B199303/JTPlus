//
//  Observerable+Cache.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

import RxSwift
import Moya

extension ObservableType where Element: TargetType, Element: Cacheable, Element.ResponseType == Moya.Response {
    
    public func request() -> Observable<Moya.Response> {
        return flatMap { target -> Observable<Moya.Response> in
            let source = target.request()
                .storeCachedResponse(for: target)
                .asObservable()
            
            if let response = try? target.cachedResponse(),
                target.allowsStorage(response) {
                return source.startWith(response)
            }
            
            return source
        }
    }
}
