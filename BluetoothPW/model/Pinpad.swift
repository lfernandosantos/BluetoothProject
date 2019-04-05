//
//  Pinpad.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 11/03/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation
import CoreBluetooth

enum PinpadCommands: String {
    case open           = "OPN"
    case getInfo        = "GIN"
    case display        = "DSP"
    case close          = "CLO"
    case getCard        = "GCR"
    case startGetCard
    case goOnChip       = "GOC"
    case getTimeStamp   = "GTS"
    case tableLoadInit  = "TLI"
    case tableLoadRec   = "TLR"
    case tableLoadEnd   = "TLE"
    case finishChip     = "FNC"
    case nak            = "NAK"
    case error
    
    static func getFromString(function: String?) -> PinpadCommands {
        if let function = function, let command = PinpadCommands.init(rawValue: function) {
            return command
        } else {
            return self.error
        }
    }
}


struct PinPad {
    
    var device: CBPeripheral
    
    func readData(data: Data) {
        
    }
    
    
    func loadTable(){
        
    }
    
    func finishLoadTable(){
        
    }
}
