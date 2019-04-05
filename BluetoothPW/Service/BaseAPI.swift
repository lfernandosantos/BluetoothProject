//
//  BaseAPI.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 03/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

protocol BaseAPI {
    var urlBase: URL { get }
    var path: String { get }
}

internal enum BaseEndPoint {
    case initialization
}

extension BaseEndPoint: BaseAPI {
    var urlBase: URL {
        return URL(string: "https://private-e43fd-apiinit.apiary-mock.com/")!
    }
    
    var path: String {
        switch self {
        case .initialization:
            return "initialization"
        }
        
    }
}


enum HTTPMethodAPI: String {
    case get    = "GET"
    case post   = "POST"
}


enum HTTPHeadersValue: String {
    case applicationJSON  = "application/json; charset=utf-8"
    
}


enum HTTPHeadersKey: String {
    case contentType    = "Content-Type"
    case authorization  = "Authorization"
}


enum ResultAPI<T, String> {
    case success(T)
    case failure(String)
}
