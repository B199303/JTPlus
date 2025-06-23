//
//  AddReportDataRecord.swift
//  WorkerManage
//
//  Created by BL L on 2023/11/21.
//

import GRDB
import ObjectiveC

class AddReportDataRecord: NSObject {
    var carbonCopyUserIdList: [Int] = []    //抄送用户列表
    var detail: [[String:Any]] = []         //具体内容
    var id:Int? = nil                       //汇报名称id,修改时必传
    var name:String = ""                    //
    var receiverUserIdList: [Int] = []      //接受者用户列表
    var reportDate:String? = nil            //汇报时间,如果不是补交，其实就等于更新时间,supplementary 为1时，必填
    var templateId:Int = 0
    

    init(dict:[String:Any]){
        let carbonCopyUserIdList = dict["carbonCopyUserIdList"] as? [Int] ?? []
        let detail = dict["detail"] as? [[String:Any]] ?? []
        let id = dict["id"] as? Int ?? 0
        let name = dict["name"] as? String ?? ""
        let receiverUserIdList = dict["receiverUserIdList"] as? [Int] ?? []
        let reportDate = dict["reportDate"] as? String ?? ""
        let templateId = dict["templateId"] as? Int ?? 0

        self.carbonCopyUserIdList = carbonCopyUserIdList
        self.detail = detail
        self.id = id
        self.name = name
        self.receiverUserIdList = receiverUserIdList
        self.reportDate = reportDate
        self.templateId = templateId

        super.init()
    }
}


class ReportDataContent: Record {
    var contentStr: String = ""
    var msgId: Int = 0
    
    override init(){
        super.init()
    }
    
    override class var databaseTableName: String {
        "Report_records"
    }
    
    enum Columns: String, ColumnExpression {
        case contentStr, msgId
    }
    
    required init(row: Row) {
        contentStr = row[Columns.contentStr]
        msgId = row[Columns.msgId]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.msgId] = msgId
        container[Columns.contentStr] = contentStr
    }
}
