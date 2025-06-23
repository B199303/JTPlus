//
//  Storable.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

public protocol Cacheable {
    associatedtype ResponseType
    
    var allowStorage: (ResponseType) -> Bool { get }
    
    func cachedResponse(for key: String) throws -> ResponseType
    
    func storeCachedResponse(_ cachedResponse: ResponseType, for key: String) throws
    
    func removeCachedResponse(for key: String) throws
    
    func removeAllCachedResponses() throws
}
