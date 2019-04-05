//
//  LoadTable.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 02/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation


struct LoadTable {
    let tableId:        String
    let acquirerId:     Common.AcquirerID
    let registerIndex:  String
    let aid:            String
    let applicationType:        ApplicationType
    
    static func from(bc message: String) -> LoadTable {
        let bc_tableId = message.substring(fromIndex: 3, toIndex: 4)
        let bc_acquirerId = message.substring(fromIndex: 4, toIndex: 6)
        let bc_registerIndex = message.substring(fromIndex: 6, toIndex: 8)
        let bc_aidSize = message.substring(fromIndex: 8, toIndex: 10)
        let size_aid = Int(bc_aidSize) ?? 32
        let bc_aid = message.substring(fromIndex: 10, toIndex: (size_aid + 10) )
        let bc_applicationType = message.substring(fromIndex: 42, toIndex: 44)
        
        let acquirer = Common.AcquirerID(rawValue: bc_acquirerId) ?? .all
        let app = ApplicationType(rawValue: bc_applicationType) ?? .credito
        
        return self.init(tableId: bc_tableId, acquirerId: acquirer, registerIndex: bc_registerIndex, aid: bc_aid, applicationType: app)
        
    }
}
