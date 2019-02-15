//
//  CalculoCRC.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 11/02/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation


struct CalculoCRC {
    
    func prepareDataToCRC(ppFunc: String) -> [UInt8] {
        
        let data = Data(ppFunc.utf8)
        var bytes = [UInt8](data)
        let etb: UInt8 = 0x17
        bytes.append(etb)
        
        return bytes
    }
    
    
    func crcXModem(bytes: [UInt8]) -> UInt16 {
        
        var crc: UInt16 = 0x0000          // initial value
        let polynomial: UInt16 = 0x1021   // 0001 0000 0010 0001  (0, 5, 12)
        
        for by in bytes {
            
            for i in 0..<8 {
                let bit = ((by  >> (7-i) & 1) == 1)
                let c15 = ((crc >> 15    & 1) == 1)
                
                crc <<= 1
                
                if (c15 != bit) {
                    crc ^= polynomial
                }
            }
            crc &= 0xffff
        }
        
        return crc
    }

}
