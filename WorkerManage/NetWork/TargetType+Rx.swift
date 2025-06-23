import RxSwift
import Moya

public extension TargetType {
    
    func request() -> Single<Moya.Response> {
        return Network.default.provider.rx.request(.target(self))
    }
}
