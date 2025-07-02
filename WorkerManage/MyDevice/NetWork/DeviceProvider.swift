//
//  DeviceProvider.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/11.
//

import UIKit
import Moya
import ObjectMapper
import ObjectiveC
import RxSwift

class DeviceProvider {
    private let provider: MoyaProvider<DeviceApi>
    
    init(){
        let logger = NetworkLoggerPlugin()
        logger.configuration.logOptions = .verbose
        self.provider = MoyaProvider<DeviceApi>(plugins:[])
    }
    
    func getProductList(userId:Int) -> Single<ProductList>{
        return Single<ProductList>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getProductListByUser(userId: userId))
                .mapObject(ProductList.self)
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

    func getDeviceList(productId:Int) -> Single<DeviceList>{
        return Single<DeviceList>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getDeviceList(productId:productId))
                .mapObject(DeviceList.self)
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
    
    func getDeviceMetrics(deviceId:Int) -> Single<DeviceMetrics>{
        return Single<DeviceMetrics>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getDeviceMetrics(deviceId:deviceId))
                .mapObject(DeviceMetrics.self)
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
    
    func getProductMetrics(productId:Int) -> Single<DeviceMetrics>{
        return Single<DeviceMetrics>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getProductMetrics(productId:productId))
                .mapObject(DeviceMetrics.self)
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
    
    func getDeviceDetail(deviceId:Int) -> Single<DeviceDetail>{
        return Single<DeviceDetail>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getDeviceDetail(deviceId: deviceId))
                .mapObject(DeviceDetail.self)
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
    
    func getDeviceAlarmStatic(deviceId:Int, startTime:String? = nil, endTime:String? = nil) -> Single<DeviceAlarmStatic>{
        return Single<DeviceAlarmStatic>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getDeviceAlarmStatic(deviceId: deviceId, startTime: startTime, endTime: endTime))
                .mapObject(DeviceAlarmStatic.self)
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
    
    func changeDeviceMessage(deviceId:Int, deviceName:String, deviceLocation:String) -> Single<LoginResult>{
        return Single<LoginResult>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.changeDeviceMessage(deviceId: deviceId, deviceName: deviceName, deviceLocation: deviceLocation))
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
    
    func unbindDevice(deviceId:Int) -> Single<LoginResult>{
        return Single<LoginResult>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.unBindDevice(deviceId: deviceId))
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
    
    func bindDevice(deviceIdentify:String, productIdentify:String, qrCodeKey:String) -> Single<LoginResult>{
        return Single<LoginResult>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.bindDevice(deviceIdentify: deviceIdentify, productIdentify: productIdentify, qrCodeKey: qrCodeKey))
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
    
    func getDeviceAlarmList(deviceId:Int, page:Int, startTime:String? = nil, endTime:String? = nil, status:Int? = nil) -> Single<DeviceAlarmList>{
        return Single<DeviceAlarmList>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.alarmList(deviceId: deviceId, limit: 10, page: page, startTime: startTime, endTime: endTime, status: status))
                .mapObject(DeviceAlarmList.self)
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
    
    func getDeviceLastAlarmList() -> Single<DeviceAlarmList>{
        return Single<DeviceAlarmList>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.lastAlarmList)
                .mapObject(DeviceAlarmList.self)
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
    
    func getDeviceMetricsList(deviceId:Int? = nil, productId:Int? = nil, startTime:String? = nil, endTime:String? = nil) -> Single<DeviceMetricsList>{
        return Single<DeviceMetricsList>.create { [weak self] observer in
            guard let `self` = self else {
                return Disposables.create()
            }
            let innderDisposable = self.provider.rx.request(.getDeviceMetricsList(deviceId: deviceId, productId: productId, startTime: startTime, endTime: endTime))
                .mapObject(DeviceMetricsList.self)
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
}
