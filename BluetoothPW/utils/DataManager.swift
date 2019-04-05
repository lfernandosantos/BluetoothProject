//
//  DataManager.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 02/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

class DataManager {
    static let appRegisterIdCreditKey = "applicationRegistersIDCredit"
    static let appRegisterIdDebitKey = "applicationRegistersIDDebit"
    
    static func saveUserDefault(key: String, value: String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func loadFromUserDefault(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func getCreditEntries() -> [String] {
        if let data = loadFromUserDefault(key: appRegisterIdCreditKey) {
            let entries = data.components(separatedBy: ";")
            
            return entries
        }
        return []
    }
    
    static func setCreditEntries(entries: [String]) {
        
        var data: String = ""
        
        for index in 0...entries.count - 1 {
            if index == 0 {
                data = entries[index]
            } else {
                data += ";\(entries[index])"
            }
        }
        saveUserDefault(key: appRegisterIdCreditKey, value: data)
    }
    
    static func getDebitEntries() -> [String] {
        if let data = loadFromUserDefault(key: appRegisterIdDebitKey) {
            let entries = data.components(separatedBy: ";")
            
            return entries
        }
        return []
    }
    
    static func setDebitEntries(entries: [String]) {
        
        var data: String = ""
        
        if entries.count > 1 {
            for index in 0...entries.count - 1 {
                if index == 0 {
                    data = entries[index]
                } else {
                    data += ";\(entries[index])"
                }
            }
        } else {
            entries.forEach { (value) in
                data = value
            }
        }
        
        saveUserDefault(key: appRegisterIdDebitKey, value: data)
    }
}
