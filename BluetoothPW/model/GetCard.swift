//
//  GetCard.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 28/03/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation


struct GetCard {
    var typeCard: String
    let lastReadStatus: String
    let applicationSelected: String
    let acquirerId: String
    let indexRegister: String
    let firstTrailSize: String?
    let firstTrail: String?
    let secondTrailSize: String?
    let secondTrail: String?
    let thirdTrailSize: String?
    let thirdTrail: String?
    let panSize: String
    let pan: String
    let appPANSequenceNumber: String
    let applicationLabel: String
    let serviceCode: String
    let cardholderName: String
    let applicationExpirationDate: String
    let externNumberCardSize: String
    let externNumberCard: String
    let cashBackBalance: String
    let issuerContryCode: String
    let sizeDataAcquirer: String?
    let dataAcquirer: String?
    
    static func from(bc message: String) -> GetCard {
        let bc_typeCard = message.substring(fromIndex: 0, toIndex: 2)
        let bc_lastReadStatus = message.substring(fromIndex: 2, toIndex: 3)
        let bc_applicationSelected = message.substring(fromIndex: 3, toIndex: 5)
        let bc_acquirerId = message.substring(fromIndex: 5, toIndex: 7)
        let bc_indexRegister = message.substring(fromIndex: 7, toIndex: 9)
        let bc_firstTrailSize = message.substring(fromIndex: 9, toIndex: 11)
        let bc_firstTrail = message.substring(fromIndex: 11, toIndex: 87)
        let bc_secondTrailSize = message.substring(fromIndex: 87, toIndex: 89)
        let bc_secondTrail = message.substring(fromIndex: 89, toIndex: 126)
        let bc_thirdTrailSize = message.substring(fromIndex: 126, toIndex: 129)
        let bc_thirdTrail = message.substring(fromIndex: 129, toIndex: 233)
        let bc_panSize = message.substring(fromIndex: 233, toIndex: 235)
        let bc_pan = message.substring(fromIndex: 235, toIndex: 254)
        let bc_appPANSequenceNumber = message.substring(fromIndex: 254, toIndex: 256)
        let bc_applicationLabel = message.substring(fromIndex: 256, toIndex: 272)
        let bc_serviceCode = message.substring(fromIndex: 272, toIndex: 275)
        let bc_cardholdName = message.substring(fromIndex: 275, toIndex: 301)
        let bc_applicationExpirationDate = message.substring(fromIndex: 301, toIndex: 307)
        let bc_externNumberCardSize = message.substring(fromIndex: 307, toIndex: 309)
        let bc_externNumberCard = message.substring(fromIndex: 309, toIndex: 328)
        let bc_cashbackBalance = message.substring(fromIndex: 328, toIndex: 336)
        let bc_issuerCountryCode = message.substring(fromIndex: 336, toIndex: 339)
        let bc_sizeDataAcquirer = message.substring(fromIndex: 339, toIndex: 342)
        var bc_dataAcquirer: String?
        if let sizeDataAcq = Int(bc_sizeDataAcquirer), sizeDataAcq > 0 {
            bc_dataAcquirer = message.substring(fromIndex: 342, toIndex: 342 + sizeDataAcq)
        } else {
            bc_dataAcquirer = nil
        }
        
        
        return GetCard(typeCard: bc_typeCard, lastReadStatus: bc_lastReadStatus, applicationSelected: bc_applicationSelected, acquirerId: bc_acquirerId, indexRegister: bc_indexRegister, firstTrailSize: bc_firstTrailSize, firstTrail: bc_firstTrail, secondTrailSize: bc_secondTrailSize, secondTrail: bc_secondTrail, thirdTrailSize: bc_thirdTrailSize, thirdTrail: bc_thirdTrail, panSize: bc_panSize, pan: bc_pan, appPANSequenceNumber: bc_appPANSequenceNumber, applicationLabel: bc_applicationLabel, serviceCode: bc_serviceCode, cardholderName: bc_cardholdName, applicationExpirationDate: bc_applicationExpirationDate, externNumberCardSize: bc_externNumberCardSize, externNumberCard: bc_externNumberCard, cashBackBalance: bc_cashbackBalance, issuerContryCode: bc_issuerCountryCode, sizeDataAcquirer: bc_sizeDataAcquirer, dataAcquirer: bc_dataAcquirer)
    }
    
}
