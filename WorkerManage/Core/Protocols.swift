//
//  Protocols.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation
import RxSwift

protocol IAppManager {
    var didBecomeActiveObservable: Observable<()> { get }
    var willEnterForegroundObservable: Observable<()> { get }
}

protocol IAppVersionManager {
    func checkLatestVersion()
    var newVersionObservable: Observable<AppVersion?> { get }
}

protocol ISystemInfoManager {
    var appVersion: AppVersion { get }
    var passcodeSet: Bool { get }
    var deviceModel: String { get }
    var osVersion: String { get }
}

public protocol IPinKitDelegate: AnyObject {
    func onLock(delegate: IUnlockDelegate)
}

public protocol IUnlockDelegate: AnyObject {
    func onUnlock()
    func onCancelUnlock()
}

protocol ILockScreenRouter {
    func reloadAppInterface()
}

public protocol IPinKit: AnyObject {
    func set(delegate: IPinKitDelegate?)

    var isPinSet: Bool { get }
    var isPinSetObservable: Observable<Bool> { get }
    var biometryType: BiometryType? { get }
    var biometryTypeObservable: Observable<BiometryType> { get }
    func clear() throws

    var biometryEnabled: Bool { get set }

    var isLocked: Bool { get }
    func lock()
    func didFinishLaunching()
    func didEnterBackground()
    func willEnterForeground()

    var editPinModule: UIViewController { get }
    func setPinModule(delegate: ISetPinDelegate) -> UIViewController
    func unlockPinModule(delegate: IUnlockDelegate, biometryUnlockMode: BiometryUnlockMode, insets: UIEdgeInsets, cancellable: Bool, autoDismiss: Bool) -> UIViewController
}

protocol IAppConfigProvider {
    var companyWebPageLink: String { get }
    var appWebPageLink: String { get }
    var reportEmail: String { get }
    
    var h5domain: String { get }
    var domain: String { get }
    var baseURL: String { get }
    var isUAT: Bool { get }
    var version: String { get }
    var shareURL: String { get }
}


protocol IPushOrderRecordStorage {
    var orderRecords: [PushRecordContent] { get }
    func save(record: PushRecordContent)
    func save(records: [PushRecordContent])
    func delete(record: PushRecordContent)
    func delete(msgid: Int)
    func deleteAllOrderRecords()
}
