//
//  MyDeviceNoticeViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/16.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MyDeviceNoticeViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = DeviceProvider()
    let listRelay = BehaviorRelay<[DeviceAlarmListData]>(value: [])
    
    override init() {
        super.init()
    }
    
    func getAlarmList(){
        dataProvider.getDeviceLastAlarmList().subscribe(onSuccess: {[weak self] data in
            guard let `self` = self else {return}
            if data.code == 20000 {
                self.listRelay.accept(data.data)
            }
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MyDeviceNoticeViewModel{
    var listDriver:Driver<[DeviceAlarmListData]>{
        self.listRelay.asDriver()
    }
}
