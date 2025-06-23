//
//  CachingKey+Moya.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

import Moya

extension TargetType {
    var cachedKey: String {
        if let urlRequest = try? endpoint.urlRequest(), let data = urlRequest.httpBody, let parameters = String(data: data, encoding: .utf8) {
            return "\(method.rawValue):\(endpoint.url)?\(parameters)"
        }
        
        if case let .requestParameters(parameters, _) = endpoint.task {
            let params = parameters.sorted { $0.0 < $1.0 }
            let paramstr = params.description
            return "\(method.rawValue):\(endpoint.url):\(paramstr)"
        }
        
        return "\(method.rawValue):\(endpoint.url)"
    }
    
    var endpoint: Endpoint {
        return Endpoint(url: URL(target: self).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, self.sampleData) },
                        method: method,
                        task: task, httpHeaderFields: headers)
    }
}
