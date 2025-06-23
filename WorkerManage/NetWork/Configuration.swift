import Moya

public extension Network {
    
    class Configuration {
        
        public static var `default`: Configuration = Configuration()
        
        public var addingHeaders: (TargetType) -> [String: String] = { t in
            return Network.sharedHeaders()
        }
        
        public var replacingTask: (TargetType) -> Task = { $0.task }
        
        public var timeoutInterval: TimeInterval = 10
        
        public var plugins: [PluginType] = []
        
        public init() {
            let logger = NetworkLoggerPlugin()
            logger.configuration.logOptions = .verbose
            
            plugins = [logger, ResponsePlugin()]
        }
    }
}
