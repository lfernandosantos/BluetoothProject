//
//  RequestData.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 03/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

struct RequestData {
    let path:       URL
    let method:     HTTPMethodAPI
    let params:     [String: Any]?
    let headers:    [String: String]?
    
    
    init(endPoint: BaseEndPoint, method: HTTPMethodAPI, params: [String: Any]? = nil, headers: [String: String]? = nil) {
        self.path       = URL(string: endPoint.urlBase.absoluteString + endPoint.path)!
        self.method     = method
        self.params     = params
        self.headers    = headers
        
    }
}
