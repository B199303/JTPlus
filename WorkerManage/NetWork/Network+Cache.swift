//
//  Network+Cache.swift
//  Networking
//
//  Created by zhangj on 2020/7/9.
//  Copyright © 2020 taibi. All rights reserved.
//

import Moya
import CryptoKit

extension Cacheable where Self: TargetType {
    
    private var cachedURL: URL {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory,
            .userDomainMask,
            true).last
        else {
            fatalError("Couldn't search cache's directory.")
        }
        
        return URL(fileURLWithPath: path)
    }
    
    public var allowsStorage: (Response) -> Bool {
        return { _ in true }
    }
    
    public func cachedResponse(for key: String) throws -> Response {
        let data = try Data(contentsOf: fileURL(key))
        
        return Response(statusCode: 200, data: data)
    }
    
    public func storeCachedResponse(_ cachedResponse: Response, for key: String) throws {
        try cachedResponse.data.write(to: fileURL(key))
    }
    
    public func removeCachedResponse(for key: String) throws {
        try FileManager.default.removeItem(at: fileURL(key))
    }
    
    public func removeAllCachedResponses() throws {
        try FileManager.default.removeItem(at: cachedURL)
    }
    
    private func fileURL(_ key: String) -> URL {
        guard let data = key.data(using: .utf8) else {
            return cachedURL.appendingPathComponent(key)
        }
        let digest = SHA256.hash(data: data)
        return cachedURL.appendingPathComponent(digest.hexStr)
    }
}


extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}
