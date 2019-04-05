//
//  InitializationRequest.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 03/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

struct InitializationRequest {
    let mti, processingCode, transmissionDate, stan: String
    let transactionDate, acquirerID, terminalID, merchantID: String
    let customerID, manufacturer, pverfm, serialNumber: String
    let chipLibraryVersion, emvKernelVersion, browserVersion, posnetVersion: String
    let ipVersion, applicationVersion, connectionMode, connectionDetails: String
    let pinpadSerialNumber, pinpadFirmware, initializationFormatVersion, model: String
    let memoryCapacity: String
}
