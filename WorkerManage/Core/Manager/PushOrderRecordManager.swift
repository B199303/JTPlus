//
//  PushOrderRecordManager.swift
//  WorkerManage
//
//  Created by BL L on 2022/11/2.
//


import UIKit
import RxSwift
import RxRelay

class PushOrderRecordManager {

    private let storage: IPushOrderRecordStorage
    
    init(storage: IPushOrderRecordStorage) {
        self.storage = storage
    }
    
}

extension PushOrderRecordManager {
    func save(record:PushRecordContent){
        storage.save(record: record)
    }
    
    func delete(record:PushRecordContent) {
        storage.delete(record: record)
    }
    
    func delete(msgid: Int){
        storage.delete(msgid: msgid)
    }
    
    var orderRecords: [PushRecordContent] {
        storage.orderRecords
    }
    
    func clear() {
        storage.deleteAllOrderRecords()
    }
    
    
}


