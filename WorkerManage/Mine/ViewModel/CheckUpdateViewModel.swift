//
//  CheckUpdateViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2025/6/16.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class CheckUpdateViewModel: NSObject {
    private let disposeBag = DisposeBag()
    let dataProvider = NetProvider()
    let checkDataRelay = BehaviorRelay<CheckVersionData?>(value:nil)
    let historyDataRelay = BehaviorRelay<[CheckVersionData]>(value: [])
    
    override init() {
        super.init()
    }
    
    func checkVersion(){
        dataProvider.checkVersion().subscribe(onSuccess: { [weak self] data in
            self?.checkDataRelay.accept(data.data)
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func getHistory(){
        dataProvider.getVersionHistory().subscribe(onSuccess: { [weak self] data in
            self?.historyDataRelay.accept(data.data)
        }, onFailure: {err in
            print(err)
        }).disposed(by: disposeBag)
    }
}

extension CheckUpdateViewModel{
    var checkDataDriver:Driver<CheckVersionData?>{
        self.checkDataRelay.asDriver()
    }
    
    var historyDataDriver: Driver<[CheckVersionData]>{
        self.historyDataRelay.asDriver()
    }
}
