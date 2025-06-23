//
//  GrdbStorage.swift
//  WorkerManage
//
//  Created by BL L on 2022/11/2.
//


import Foundation
import RxSwift
import RxCocoa
import GRDB

class GrdbStorage {
    private let dbPool: DatabasePool

    private let appConfigProvider: IAppConfigProvider

    init(appConfigProvider: IAppConfigProvider) {
        self.appConfigProvider = appConfigProvider

        let databaseURL = try! FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("order.sqlite")

        dbPool = try! DatabasePool(path: databaseURL.path)

        try! migrator.migrate(dbPool)
    }

    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createPushRecordsTable") { db in
            try db.create(table: PushRecordContent.databaseTableName) { t in
                t.column(PushRecordContent.Columns.msgId.name, .integer).notNull()
                t.column(PushRecordContent.Columns.contentStr.name, .text).notNull()

                t.primaryKey([
                    PushRecordContent.Columns.msgId.name
                ], onConflict: .replace)
            }
        }

        return migrator
    }

}

extension GrdbStorage:IPushOrderRecordStorage{
    var orderRecords: [PushRecordContent]{
        return try! dbPool.read { db in
            try PushRecordContent.fetchAll(db)
        }
    }
    
    func save(records: [PushRecordContent]) {
        _ = try! dbPool.write { db in
            for record in records {
                try record.insert(db)
            }
        }
    }
    
    func save(record: PushRecordContent) {
        _ = try! dbPool.write { db in
            try record.insert(db)
        }
    }
    
    func delete(record: PushRecordContent) {
        _ = try! dbPool.write { db in
            try PushRecordContent.filter(PushRecordContent.Columns.msgId == record.msgId).deleteAll(db)
        }
    }
    
    func delete(msgid: Int) {
        _ = try! dbPool.write { db in
            try PushRecordContent.filter(PushRecordContent.Columns.msgId == msgid).deleteAll(db)
        }
    }
    
    func deleteAllOrderRecords(){
        _ = try! dbPool.write { db in
            try PushRecordContent.deleteAll(db)
        }
    }
}


