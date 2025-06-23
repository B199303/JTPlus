import Foundation
import Moya
import UIKit
import RxSwift
import RxCocoa

public final class ResponsePlugin: PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var req = request
        req.timeoutInterval = 10
        return request
    }
}
