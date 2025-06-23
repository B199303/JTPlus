//
//  AppManager.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import RxSwift

class AppManager {

    private let didBecomeActiveSubject = PublishSubject<()>()
    private let willEnterForegroundSubject = PublishSubject<()>()
    private let willEnterBackgroundSubject = PublishSubject<()>()

    init(
    ) {
    }

}

extension AppManager {

    func didFinishLaunching() {
    }

    func willResignActive() {

    }

    func didBecomeActive() {
        didBecomeActiveSubject.onNext(())

    }

    func didEnterBackground() {
        willEnterBackgroundSubject.onNext(())
    }

    func willEnterForeground() {
        willEnterForegroundSubject.onNext(())
    }

    func willTerminate() {
    }

    func didReceivePushToken(tokenData: Data) {
    }

}

extension AppManager: IAppManager {

    var didBecomeActiveObservable: Observable<()> {
        didBecomeActiveSubject.asObservable()
    }

    var willEnterForegroundObservable: Observable<()> {
        willEnterForegroundSubject.asObservable()
    }
    
    var willEnterBackgroundObservable: Observable<()> {
        willEnterBackgroundSubject.asObservable()
    }

}
