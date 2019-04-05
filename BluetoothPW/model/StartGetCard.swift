//
//  StartGetCard.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 01/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation


struct StartGetCard {
    let idAcquirer: String
    let applicationType: String
    let transactionValue: Int
    let transactionDate: String
    let transactionHour: String
    let timeStamp: String
    let entries:[String]
    let supportCTLS: String?
    
    
    func getStartGetCardInput() -> String {
        var input: String
        input = idAcquirer
        input += applicationType
        input += String(format: "%012d", transactionValue)
        input += transactionDate
        input += transactionHour
        input += timeStamp
        input +=  String(format: "%02d", entries.count)
        entries.forEach{ input += $0}
        input += supportCTLS ?? ""
        
        return input
    }
}
