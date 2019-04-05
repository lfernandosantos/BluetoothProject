//
//  BaseService.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 03/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

protocol BaseService {
    func request(requestData: RequestData,
                 completion: @escaping (ResultAPI<Data, String>, Int? ) -> Void)
}


extension BaseService {
    
    internal func request(requestData: RequestData,
                          completion: @escaping (ResultAPI<Data, String>, Int? ) -> Void) {
        
        var post = URLRequest(url: requestData.path)
        post.httpMethod = requestData.method.rawValue
        
        if let headers = requestData.headers {
            headers.forEach { (value) in
                post.setValue(value.value, forHTTPHeaderField: value.key)
            }
        } else {
            post.setValue(HTTPHeadersValue.applicationJSON.rawValue,
                          forHTTPHeaderField: HTTPHeadersKey.contentType.rawValue)
        }
        
        if let params = requestData.params {
            let body = try? JSONSerialization.data(withJSONObject: params, options: [])
            post.httpBody = body
        }
        
        print(post)
        let session = URLSession.shared
        
        session.dataTask(with: post) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    
                    completion(ResultAPI.failure(error.localizedDescription), nil)
                } else {
                    
                    let httpResponse = response as? HTTPURLResponse
                    let data = data ?? Data()
                    completion(ResultAPI.success(data), httpResponse?.statusCode)
                }
            }
            }.resume()
    }
    
}
