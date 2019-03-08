//
//  GetInfo.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 07/03/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

enum GetInfoType {
    case general
    case acquirer
}

protocol GetInfo: class {
    var applicationVersion: String { get}
    var type: GetInfoType {get set}
}


class GetInfoAcquirer: GetInfo {
    let applicationVersion: String
    
    var type: GetInfoType
    
    let acquirer: String
    let acquirerInfo: String
    let idSAMSize: String
    let idSAM: String
    
    required init(applicationVersion: String, acquirer: String, acquirerInfo: String, idSAMSize: String, idSAM: String) {
        self.applicationVersion = applicationVersion
        self.type = .acquirer
        self.acquirer = acquirer
        self.acquirerInfo = acquirerInfo
        self.idSAMSize = idSAMSize
        self.idSAM = idSAM
    }
}

class GetInfoGeneral: GetInfo {

    let applicationVersion: String
    var type: GetInfoType
    let manufacturer: String
    let model: String
    let contactlessSupport: Bool
    let firmwareVersion: String
    let especificationVersion: String
    let serialNumber: String
    
    required init(applicationVersion: String, manufacturer: String, model: String, contactlessSupport: Bool,
                  firmwareVersion: String, especificationVersion: String, serialNumber: String) {
        self.applicationVersion = applicationVersion
        self.type = .general
        self.manufacturer = manufacturer
        self.model = model
        self.contactlessSupport = contactlessSupport
        self.firmwareVersion = firmwareVersion
        self.especificationVersion = especificationVersion
        self.serialNumber = serialNumber
    }
}
