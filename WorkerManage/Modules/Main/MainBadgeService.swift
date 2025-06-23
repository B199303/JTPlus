//
//  MainBadgeService.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation
import RxSwift
import RxRelay

class MainBadgeService {
    private let disposeBag = DisposeBag()

    private let settingsBadgeRelay = BehaviorRelay<Bool>(value: false)

    init() {
        syncSettingsBadge()
    }

    var settingsBadgeObservable: Observable<Bool> {
        settingsBadgeRelay.asObservable()
    }

    private func syncSettingsBadge() {
    }

}
