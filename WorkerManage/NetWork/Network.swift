import Moya
//import LanguageKit

open class Network {
    
    public static let `default`: Network = {
        Network(configuration: Configuration.default)
    }()
    
    public let provider: MoyaProvider<MultiTarget>
    
    public init(configuration: Configuration) {
        provider = MoyaProvider(configuration: configuration)
    }
    
    public static func sharedHeaders() -> [String: String] {
        var headers = [String: String]()
        
        
//        var lang = ""
//        let la = LanguageManager.shared.currentLanguage
//        if la == "zh-Hant" {
//            lang = "zh"
//        } else if la == "zh-Hans" {
//            lang = "cn"
//        } else {
//            lang = la
//        }
//        headers["version"] = App.shared.systemInfoManager.appVersion.version
//        headers["XXX-DOMAIN"] = App.shared.appConfigProvider.domain
////        headers["lang"] = lang
//        headers["channel_number"] = Bundle.main.bundleIdentifier
//        if App.shared.uuidManager.uuid.count > 0 {
//            let uuid = App.shared.uuidManager.uuid[0].uuid
//            headers["XXX-UUID"] = uuid
//        }
        
        if let data = UserDefaults.standard.string(forKey: "token")  {
            if data != ""{
                headers["Authorization"] = "Bearer " + data
            }
        }
        headers["version"] = App.shared.appConfigProvider.version
        headers["deviceSign"] = "ios"
        headers["appVersion"] = "1.0.0"
        return headers
    }
}

public extension MoyaProvider {
    
    convenience init(configuration: Network.Configuration) {
        
        let endpointClosure = { target -> Endpoint in
            MoyaProvider.defaultEndpointMapping(for: target)
                .adding(newHTTPHeaderFields: configuration.addingHeaders(target))
                .replacing(task: configuration.replacingTask(target))
        }
        
        let requestClosure =  { (endpoint: Endpoint, closure: RequestResultClosure) -> Void in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = configuration.timeoutInterval
                closure(.success(request))
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(.parameterEncoding(error)))
            } catch {
                closure(.failure(.underlying(error, nil)))
            }
        }
        
        self.init(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            plugins: configuration.plugins
        )
    }
}
