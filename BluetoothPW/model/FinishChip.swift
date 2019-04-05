//
//  FinishChip.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 02/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

struct FinishChip {
    let comunicationStatus: String
    let emitterType: String
    let authotizationResponseCode: String
    let field55: String
    let acquirerEntries: String
    let psTags: String
    
    
    func getFinishChipInput() -> String {
        var input: String
        input = comunicationStatus
        input += emitterType
        input += authotizationResponseCode
        
        if field55.count > 1 {
            input += String(format: "%03d", (field55.count / 2) )
        } else {
            input += String(format: "%03d", field55.count )
        }
        input += String(format: "%03d", acquirerEntries.count)
        input += acquirerEntries
        
        return input
    }
    
    func getPsTagsInput() -> String {
        var input: String
        
        if psTags.count > 1 {
            input = String(format: "%03d", (psTags.count / 2) )
        } else {
            input = String(format: "%03d", psTags.count )
        }
        input += psTags
        
        return input
    }
}
