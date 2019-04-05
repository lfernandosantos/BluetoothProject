//
//  GoOnChip.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 28/03/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation


struct GoOnChip {
    let decision: String
    let needAsign: String
    let pinVerifiedOff: String
    let pinvalidAppearsOff: String
    let pinOffBloquedLastAppear: String
    let pinToVerifyOn: String
    let encryptedPin: String?
    let keySerialNumber: String?
    let isoFieldSize: String
    let emvTags: String?
    let sizeDataAquirer: String
    let dataAquirer: String?

    static func from(bc message: String) -> GoOnChip {
        let bc_decision = message.substring(fromIndex: 0, toIndex: 1)
        let bc_needAsign = message.substring(fromIndex: 1, toIndex: 2)
        let bc_pinVerifiedOff = message.substring(fromIndex: 2, toIndex: 3)
        let bc_pinNumberValidAppearsOff = message.substring(fromIndex: 3, toIndex: 4)
        let bc_pinOffBloquedLastAppear = message.substring(fromIndex: 4, toIndex: 5)
        let bc_pinToVerifyOn = message.substring(fromIndex: 5, toIndex: 6)
        var bc_encryptedPin: String? = nil
        var bc_keySerialNumber: String? = nil
        
        if bc_pinToVerifyOn == "1" {
            bc_encryptedPin = message.substring(fromIndex: 6, toIndex: 22)
            bc_keySerialNumber = message.substring(fromIndex: 22, toIndex: 42)
        }
        
        let bc_isoFieldSize = message.substring(fromIndex: 42, toIndex: 45)
        var bc_emvTags: String?
        var bc_sizeDataAquirer: String
        var bc_dataAquirer: String?
        if let emvTagsSize = Int(bc_isoFieldSize), emvTagsSize > 0 {
            bc_emvTags = message.substring(fromIndex: 45, toIndex: emvTagsSize + 45)
            bc_sizeDataAquirer = message.substring(fromIndex: emvTagsSize + 45, toIndex: emvTagsSize + 45 + 3 )
            
            if let sizeDataAquirerInt = Int(bc_sizeDataAquirer) {
                bc_dataAquirer = message.substring(fromIndex: emvTagsSize + 45 + 3, toIndex: emvTagsSize + 45 + 3 + sizeDataAquirerInt )
            }
            
        } else {
            
            bc_sizeDataAquirer = message.substring(fromIndex: 48, toIndex:  48 + 3 )
            
            if let sizeDataAquirerInt = Int(bc_sizeDataAquirer) {
                bc_dataAquirer = message.substring(fromIndex: 48 + 3, toIndex: 48 + 3 + sizeDataAquirerInt )
            }
        }
        
        return GoOnChip(decision: bc_decision, needAsign: bc_needAsign, pinVerifiedOff: bc_pinVerifiedOff, pinvalidAppearsOff: bc_pinNumberValidAppearsOff, pinOffBloquedLastAppear: bc_pinOffBloquedLastAppear, pinToVerifyOn: bc_pinToVerifyOn, encryptedPin: bc_encryptedPin, keySerialNumber: bc_keySerialNumber, isoFieldSize: bc_isoFieldSize, emvTags: bc_emvTags, sizeDataAquirer: bc_sizeDataAquirer, dataAquirer: bc_dataAquirer)
    }
}



