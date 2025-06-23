//
//  MessageViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2023/12/23.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class MessageViewModel: NSObject {
    let listRelay = BehaviorRelay<[AlarmListContent]>(value:[])
    private let endRefreshRelay = BehaviorRelay<Bool>(value: false)
    private let noMoreDataRelay = BehaviorRelay<Bool>(value: false)
    var query:String? = nil
    var startTime:String? = nil
    var endTime:String? = nil
    private var page: Int = 1
    
    let disposeBag = DisposeBag()
    let dataProvider = NetProvider()
    
    var alarmList:[AlarmListContent] = []
    
    override init() {
        super.init()
    }
    
    func getList(loadMore: Bool){
        let pgIndex = loadMore ? page + 1 : 1
        dataProvider.getAlarmList(query: query, startTime: startTime, endTime: endTime, page: pgIndex).subscribe(onSuccess: { [weak self] data in
            guard let `self` = self else {return}
            if data.code == 20000{
                self.endRefreshRelay.accept(true)
                self.noMoreDataRelay.accept(data.data.count < 10)
                self.page = pgIndex
                if loadMore {
                    self.alarmList.append(contentsOf: data.data)
                } else {
                    self.alarmList = data.data
                }
                self.listRelay.accept(self.alarmList)
            }
        }, onFailure: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension MessageViewModel{
    var listDriver: Driver<[AlarmListContent]> {
        listRelay.asDriver()
    }
    
    var endRefreshDriver: Driver<Bool> {
        endRefreshRelay.asDriver()
    }
    
    var noMoreDataDriver: Driver<Bool> {
        noMoreDataRelay.asDriver()
    }
}
