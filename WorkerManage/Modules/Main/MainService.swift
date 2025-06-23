//
//  MainService.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation
import RxSwift
import RxRelay

class MainService {
    private let disposeBag = DisposeBag()

    private let hasAccountsRelay = PublishRelay<Bool>()
    private(set) var hasAccounts: Bool = false {
        didSet {
            if oldValue != hasAccounts {
                hasAccountsRelay.accept(hasAccounts)
            }
        }
    }

    init() {
        
    }

}

extension MainService {

    var hasAccountsObservable: Observable<Bool> {
        hasAccountsRelay.asObservable()
    }

    func setMainShownOnce() {
    }

}
