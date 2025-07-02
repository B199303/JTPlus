//
//  MyDeviceProductRecordViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/25.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyDeviceProductRecordViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = DeviceProvider()
    let listRelay = BehaviorRelay<[DeviceMetricsContentData]>(value: [])
    private var page: Int = 1
    
    var startTime:String? = nil
    var endTime:String? = nil
    var deviceId:Int? = nil
    var productId: Int? = nil
    
    override init() {
        super.init()
    }
    
    func getDeviceMetricsList(){
        
        dataProvider.getDeviceMetricsList(deviceId: deviceId, productId: productId, startTime: startTime, endTime: endTime).subscribe(onSuccess: {[weak self] data in
            guard let `self` = self else {return}
            if data.code == 20000 {
                self.listRelay.accept(data.data)
            }
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MyDeviceProductRecordViewModel{
    var listDriver:Driver<[DeviceMetricsContentData]>{
        self.listRelay.asDriver()
    }
}
