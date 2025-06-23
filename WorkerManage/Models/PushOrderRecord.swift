//
//  PushOrderRecord.swift
//  WorkerManage
//
//  Created by BL L on 2022/11/2.
//

import GRDB
import ObjectiveC

class PushDataContent: NSObject {
    var clientContact: String = ""
    var clientName: String = ""
    var clientPhone: String = ""
    var orderId: Int = 0
    var orderServiceType: Int = 0
    var orderStatus: Int = 0
    var specifyProcessingDay: Int = 0
    var clientAddr : String = ""
    
    var accessoriesName: String = ""
    var accessoriesSalesOrderId: Int = 0
    var date: Int = 0
    var createUserName: String = ""
    
    var msgid: Int = 0
    var type: Int = 0
    var createTime:String = ""
    var isShow:Bool = false

    init(dict:[String:Any], type:Int){
        //供配销
        let accessoriesName = dict["accessoriesName"] as? String ?? ""
        let accessoriesSalesOrderId = dict["accessoriesSalesOrderId"] as? Int ?? 0
        let date = dict["date"] as? Int ?? 0
        let createUserName = dict["createUserName"] as? String ?? ""
        //工单
        let clientContact = dict["clientContact"] as? String ?? ""
        let orderId = dict["orderId"] as? Int ?? 0
        let orderServiceType = dict["orderServiceType"] as? Int ?? 0
        let specifyProcessingDay = dict["specifyProcessingDay"] as? Int ?? 0
        let clientAddr = dict["clientAddr"] as? String ?? ""
        //共有
        let clientName = dict["clientName"] as? String ?? ""
        let clientPhone = dict["clientPhone"] as? String ?? ""
        let orderStatus = dict["orderStatus"] as? Int ?? 0

        self.clientContact = clientContact
        self.clientName = clientName
        self.clientPhone = clientPhone
        self.orderId = orderId
        self.orderServiceType = orderServiceType
        self.orderStatus = orderStatus
        self.specifyProcessingDay = specifyProcessingDay
        self.type = type
        self.clientAddr = clientAddr
        
        self.accessoriesName = accessoriesName
        self.accessoriesSalesOrderId = accessoriesSalesOrderId
        self.date = date
        self.createUserName = createUserName

        super.init()
    }
}

class PushReportContent: NSObject {
    //未提交用户
    var deadlineHours: Int = 0
    var reportReceiverUserList: [String] = []
    var templateName: String = ""
    var templateRule: [String:Any] = [:]
    var type: Int = 0
    
    //收到提交的汇报
    var reportDate: Int = 0
    var reportId: Int = 0
    var submitterUserName: String = ""
    
    var createTime = ""
    var msgid: Int = 0

    init(dict:[String:Any]){
        if let dictContent:[String:Any] = dict["data"] as? [String : Any]{
            deadlineHours = dictContent["deadlineHours"] as? Int ?? 0
            reportReceiverUserList = dictContent["reportReceiverUserList"] as? [String] ?? []
            templateName = dictContent["templateName"] as? String ?? ""
            templateRule = dictContent["templateRule"] as? [String:Any] ?? [:]
            
            reportDate = dictContent["reportDate"] as? Int ?? 0
            reportId = dictContent["reportId"] as? Int ?? 0
            submitterUserName = dictContent["submitterUserName"] as? String ?? ""
        }
        
        type = dict["type"] as? Int ?? 0
        
        

        super.init()
    }
}


class PushRecordContent: Record {
    var contentStr: String = ""
    var msgId: Int = 0
    
    init(contentStr: String, msgId:Int){
        
        self.contentStr = contentStr
        self.msgId = msgId
        
        super.init()
    }
    
    override class var databaseTableName: String {
        "Order_records"
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
