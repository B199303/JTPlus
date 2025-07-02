//
//  NetProvider.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/22.
//

import RxSwift
import Moya
import ObjectMapper

public enum RequestError: Error {
    case invalidResponse(statusCode: Int, data: Any?)
    case noResponse(reason: String?)
    case disposed
}

class NetProvider {
    
    private let provider: MoyaProvider<NetAPI>
    
    init() {
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = .verbose
        self.provider = MoyaProvider<NetAPI>(plugins: [])
    }
    
    func getRsaKey() -> Single<GetRsaKey> {
        return Single<GetRsaKey>.create { [weak self] observer in
            guard let `self` = self else {
                
                return Disposables.create()
            }

            let innderDisposable = self.provider.rx.request(.getEntrypt)
                .mapObject(GetRsaKey.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }

    func login(account: String, pwd: String) -> Single<LoginResult>  {
        return Single<LoginResult>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }

            let innderDisposable = self.provider.rx.request(.login(account: account, pwd: pwd))
                .mapObject(LoginResult.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }
    
    func userInfo(userId:Int? = nil) -> Single<UserInfo>{
        return Single<UserInfo>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }

            let innderDisposable = self.provider.rx.request(.userInfo(userId: userId))
                .mapObject(UserInfo.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }
    
    func getAlarmList(query:String? = nil, startTime:String? = nil, endTime:String? = nil, page: Int) -> Single<AlarmListData>{
        return Single<AlarmListData>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            let innderDisposable = self.provider.rx.request(.alarmList(limit: 10, page: page, query: query, startTime: startTime, endTime: endTime))
                .mapObject(AlarmListData.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }
    
    func updateClientUserInfo(name:String? = nil, avatar:String? = nil, sex:Int? = nil, password:String? = nil, newPassword:String? = nil) -> Single<LoginResult>  {
        return Single<LoginResult>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }

            let innderDisposable = self.provider.rx.request(.updateClientUserInfo(name: name, avatar: avatar, sex: sex, password: password, newPassword: newPassword))
                .mapObject(LoginResult.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }
    
    func loginOut() -> Single<LoginResult>  {
        return Single<LoginResult>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }

            let innderDisposable = self.provider.rx.request(.loginOut)
                .mapObject(LoginResult.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }
    
    func checkVersion() -> Single<CheckVersion>  {
        return Single<CheckVersion>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }

            let innderDisposable = self.provider.rx.request(.checkVersion)
                .mapObject(CheckVersion.self)
                .subscribe { response in
                    observer(.success(response))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }
    
    func getVersionHistory() -> Single<VersionHistory> {
        return Single<VersionHistory>.create{ [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            
            let innderDisposable = self.provider.rx.request(.versionHistory(type: 1))
                .mapObject(VersionHistory.self)
                .subscribe{ res in
                    observer(.success(res))
                } onFailure: { err in
                    print(err)
                }
            return Disposables.create {
                innderDisposable.dispose()
            }
        }
    }

}
