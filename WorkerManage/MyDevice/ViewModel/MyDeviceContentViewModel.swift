//
//  MyDeviceContentViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/11.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyDeviceContentViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = DeviceProvider()
    let deviceListRelay = BehaviorRelay<[DeviceListData]>(value: [])
    let deviceMetricsRelay = BehaviorRelay<DeviceMetricsData?>(value: nil)
    
    override init() {
        super.init()
    }
    
    func getDeviceList(projectId:Int){
        dataProvider.getDeviceList(productId: projectId).subscribe(onSuccess: {[weak self] data in
            if data.code == 20000{
                self?.deviceListRelay.accept(data.data)
            }
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func getProductMetrics(projectId:Int){
        dataProvider.getProductMetrics(productId: projectId).subscribe(onSuccess: {[weak self] data in
            if data.code == 20000{
                self?.deviceMetricsRelay.accept(data.data)
            }
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MyDeviceContentViewModel {
    
    var deviceListDriver:Driver<[DeviceListData]> {
        deviceListRelay.asDriver()
    }
    
    var deviceMetricsDriver: Driver<DeviceMetricsData?>{
        deviceMetricsRelay.asDriver()
    }
}
