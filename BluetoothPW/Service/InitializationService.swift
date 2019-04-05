//
//  InitializationService.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 03/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

struct InitializationService: BaseService {
    func initialize(initializationRequest: InitializationRequest, completion: @escaping (Bool, InitializationResponseData?) -> Void) {
        
        let params: [String: Any] = [
            "initializationRequest": [
                "mti": initializationRequest.mti,
                "processingCode": initializationRequest.processingCode,
                "transmissionDate": initializationRequest.transmissionDate,
                "stan": initializationRequest.stan,
                "transactionDate": initializationRequest.transactionDate,
                "acquirerId": initializationRequest.acquirerID,
                "terminalId": initializationRequest.terminalID,
                "merchantId": initializationRequest.merchantID,
                "customerId": initializationRequest.customerID,
                "manufacturer": initializationRequest.manufacturer,
                "pverfm": initializationRequest.pverfm,
                "serialNumber": initializationRequest.serialNumber,
                "chipLibraryVersion": initializationRequest.chipLibraryVersion,
                "emvKernelVersion": initializationRequest.emvKernelVersion,
                "browserVersion": initializationRequest.browserVersion,
                "posnetVersion": initializationRequest.posnetVersion,
                "ipVersion": initializationRequest.ipVersion,
                "applicationVersion":initializationRequest.applicationVersion,
                "connectionMode": initializationRequest.connectionMode,
                "connectionDetails":initializationRequest.connectionDetails,
                "pinpadSerialNumber": initializationRequest.pinpadSerialNumber,
                "pinpadFirmware": initializationRequest.pinpadFirmware,
                "initializationFormatVersion": initializationRequest.initializationFormatVersion,
                "model": initializationRequest.model,
                "memoryCapacity": initializationRequest.memoryCapacity
            ]
        ]
        
        let requestData = RequestData(endPoint: .initialization, method: .post, params: params)
        self.request(requestData: requestData) { (result, statusCode) in
            switch result {
            case .failure(let error):
                print(error)
                completion(false, nil)
            case .success(let obj):
                
                let response = InitializationResponseData.decode(from: obj)
                
                completion(true, response)  
                
            }
        }
    }
}
