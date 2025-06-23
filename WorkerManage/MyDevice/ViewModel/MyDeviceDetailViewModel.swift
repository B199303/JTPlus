//
//  MyDeviceDetailViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/12.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyDeviceDetailViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = DeviceProvider()
    let deviceDetailRelay = BehaviorRelay<DeviceDetailData?>(value: nil)
    let deviceMetricsRelay = BehaviorRelay<DeviceMetricsData?>(value: nil)
    let deviceAlarmStaticRelay = BehaviorRelay<[DeviceAlarmStaticData]>(value: [])
    
    override init() {
        super.init()
    }
    
    func getDeviceDetailData(deviceId:Int){
        dataProvider.getDeviceDetail(deviceId: deviceId).subscribe(onSuccess: {[weak self] data in
            if data.code == 20000{
                self?.deviceDetailRelay.accept(data.data)
            }
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func getDeviceMetrics(deviceId:Int){
        dataProvider.getDeviceMetrics(deviceId: deviceId).subscribe(onSuccess: {[weak self] data in
            if data.code == 20000{
                self?.deviceMetricsRelay.accept(data.data)
            }
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func getDeviceAlarmStatic(deviceId:Int){
        dataProvider.getDeviceAlarmStatic(deviceId: deviceId).subscribe(onSuccess: {[weak self] data in
            if data.code == 20000{
                self?.deviceAlarmStaticRelay.accept(data.data)
            }
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MyDeviceDetailViewModel{
    var deviceDetailDriver:Driver<DeviceDetailData?>{
        deviceDetailRelay.asDriver()
    }
    
    var deviceMetricsDriver: Driver<DeviceMetricsData?>{
        deviceMetricsRelay.asDriver()
    }
    
    var deviceAlarmStaticDriver:Driver<[DeviceAlarmStaticData]>{
        deviceAlarmStaticRelay.asDriver()
    }
}
