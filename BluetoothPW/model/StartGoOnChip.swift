//
//  StartGoOnChip.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 01/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

struct StartGoOnChip {
    let amount:                 Int
    let cashback:               Int
    let blackListResult:        String
    let canBeOff:               String
    let requiredPINOnTEF:       String
    let encryptionMode:         String
    let masterKeyIndex:         String
    let workingKey:             String
    let trm:                    String
    let floorLimit:             String
    let targetPercentRDM:       Int
    let thresholdValueRDM:      String
    let maxTargetPercentageRDM: Int
    let entries:                [String]
    
    let psEmvTags:              String
    
    let psEmvTagsOpt:           String
    
    
    func getStartGetCardInput() -> String {
        var input: String
        
        input = String(format: "%012d", amount)
        input += String(format: "%012d", cashback)
        input += blackListResult
        input += canBeOff
        input += requiredPINOnTEF
        input += encryptionMode
        input += masterKeyIndex
        input += workingKey
        input += trm
        input += floorLimit
        input += String(format: "%02d", targetPercentRDM)
        input += thresholdValueRDM
        input += String(format: "%02d", maxTargetPercentageRDM)
        input += String(format: "%03d", entries.count)
        entries.forEach { input += $0 }
        
        return input
    }
    
    
    func getPsEmvTagsInput() -> String {
        var input: String
        if psEmvTags.count > 1 {
            input = String(format: "%03d", (psEmvTags.count / 2) )
        } else {
            input = String(format: "%03d", psEmvTags.count )
        }
        
        input += psEmvTags
        
        return input
    }
    
    
    func getPsEmvTagsOptInput() -> String {
        var input: String
        if psEmvTagsOpt.count > 1 {
            input = String(format: "%03d", (psEmvTagsOpt.count / 2) )
        } else {
            input = String(format: "%03d", psEmvTagsOpt.count )
        }
        
        input += psEmvTagsOpt
        
        return input
    }
    
}
