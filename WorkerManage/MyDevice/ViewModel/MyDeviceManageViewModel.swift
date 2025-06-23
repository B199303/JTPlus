//
//  MyDeviceManageViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/12.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyDeviceManageViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = DeviceProvider()
    let changeResultRelay = BehaviorRelay<LoginResult?>(value: nil)
    let unbindResultRelay = BehaviorRelay<LoginResult?>(value: nil)
    
    override init() {
        super.init()
    }
    
    func changeMessage(deviceId:Int, deviceName:String, deviceLocation:String){
        dataProvider.changeDeviceMessage(deviceId: deviceId, deviceName: deviceName, deviceLocation: deviceLocation).subscribe(onSuccess: {[weak self] data in
            self?.changeResultRelay.accept(data)
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func unbindDevice(deviceId:Int){
        dataProvider.unbindDevice(deviceId: deviceId).subscribe(onSuccess: {[weak self] result in
            self?.unbindResultRelay.accept(result)
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MyDeviceManageViewModel{
    var changeResultDriver:Driver<LoginResult?>{
        self.changeResultRelay.asDriver()
    }
    
    var unbindResultDriver:Driver<LoginResult?>{
        self.unbindResultRelay.asDriver()
    }
}
