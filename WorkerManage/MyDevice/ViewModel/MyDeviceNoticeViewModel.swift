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
    var data:[DeviceAlarmListData] = []
    private let endRefreshRelay = BehaviorRelay<Bool>(value: false)
    private let noMoreDataRelay = BehaviorRelay<Bool>(value: false)
    private var page: Int = 1
    
    var startTime:String? = nil
    var endTime:String? = nil
    
    override init() {
        super.init()
    }
    
    func getAlarmList(loadMore: Bool){
        let pgIndex = loadMore ? page + 1 : 1
        dataProvider.getDeviceAlarmList(page: self.page,startTime: startTime, endTime: endTime).subscribe(onSuccess: {[weak self] data in
            guard let `self` = self else {return}
            if data.code == 20000 {
                self.endRefreshRelay.accept(true)
                self.noMoreDataRelay.accept(data.data.count < 10)
                self.page = pgIndex
                if loadMore {
                    self.data.append(contentsOf: data.data)
                } else {
                    self.data = data.data
                }
                self.listRelay.accept(self.data)
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
    
    var endRefreshDriver: Driver<Bool> {
        endRefreshRelay.asDriver()
    }
    
    var noMoreDataDriver: Driver<Bool> {
        noMoreDataRelay.asDriver()
    }
}
