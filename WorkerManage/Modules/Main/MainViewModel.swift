//
//  MainViewModel.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class MainViewModel {
    private let service: MainService
    private let badgeService: MainBadgeService
    private let releaseNotesService: ReleaseNotesService
    private let jailbreakService: JailbreakService
    private let disposeBag = DisposeBag()

    private let balanceTabStateRelay = BehaviorRelay<BalanceTabState>(value: .balance)
    private let transactionsTabEnabledRelay = BehaviorRelay<Bool>(value: true)
    
    var timer: Timer?

    init(service: MainService, badgeService: MainBadgeService, releaseNotesService: ReleaseNotesService, jailbreakService: JailbreakService) {
        self.service = service
        self.badgeService = badgeService
        self.releaseNotesService = releaseNotesService
        self.jailbreakService = jailbreakService
    }

    private func sync(hasAccounts: Bool) {
        balanceTabStateRelay.accept(hasAccounts ? .balance : .onboarding)
        transactionsTabEnabledRelay.accept(hasAccounts)
    }
}

extension MainViewModel {

    var settingsBadgeDriver: Driver<Bool> {
        badgeService.settingsBadgeObservable.asDriver(onErrorJustReturn: false)
    }

    var balanceTabStateDriver: Driver<BalanceTabState> {
        balanceTabStateRelay.asDriver()
    }

    var transactionsTabEnabledDriver: Driver<Bool> {
        transactionsTabEnabledRelay.asDriver()
    }

    func onLoad() {
        service.setMainShownOnce()
    }

    func onSuccessJailbreakAlert() {
        jailbreakService.setAlertShown()
    }

}

extension MainViewModel {

    enum BalanceTabState {
        case balance
        case onboarding
    }

}
