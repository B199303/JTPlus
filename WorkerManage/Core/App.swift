//
//  App.swift
//  WorkerManage
//
//  Created by BL L on 2022/8/3.
//

import Foundation

class App {
    static let shared = App()
    
//    let pinKit: IPinKit
    let appManager: AppManager
//    let appVersionManager: IAppVersionManager
    
    let appConfigProvider: IAppConfigProvider
    let storage: IPushOrderRecordStorage
    
    init() {
        appManager = AppManager()
        appConfigProvider = AppConfigProvider()
        storage = GrdbStorage(appConfigProvider: appConfigProvider)
    }

}
