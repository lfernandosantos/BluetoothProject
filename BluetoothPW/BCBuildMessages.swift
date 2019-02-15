//
//  Pinpad.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 11/02/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation


enum PinpadCommands: String {
    case open           = "OPN"
    case getInfo        = "GIN00200"
    case display        = "DSP"
    case close          = "CLO"
    case getCard        = "GCR"
    case goOnChip       = "GOC"
    case getTimeStamp   = "GTS"
    case tableLoadInit  = "TLI"
    case tableLoadRec   = "TLR"
    case tableLoadEnd   = "TLE"
}


struct BCBuildMessages {
    
    func open() -> [UInt8]{
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: PinpadCommands.open.rawValue)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgOpen = creatPINPADMSG(data: PinpadCommands.open.rawValue, crc: getCRC)
        
        return msgOpen
    }
    
    func getInfo() -> [UInt8] {
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: PinpadCommands.getInfo.rawValue)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgGetInfo = creatPINPADMSG(data: PinpadCommands.getInfo.rawValue, crc: getCRC)
    
        return msgGetInfo

    }
    
    func close() -> [UInt8]{
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: PinpadCommands.close.rawValue)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgClo = creatPINPADMSG(data: PinpadCommands.close.rawValue, crc: getCRC)
        
        return msgClo
    }
    
    
    func showDisplay(msg: String) -> [UInt8] {
        
        var msgToSend = ""
        
        if msg.count > 32 {
            msgToSend = String(msg.prefix(32))
        } else {
            msgToSend = msg
        }
        
        let sizeMsg = String(format: "%03d", msgToSend.count)
        let displayMsg = "\(PinpadCommands.display.rawValue)\(sizeMsg)\(msgToSend)"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: displayMsg)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgShow = creatPINPADMSG(data: displayMsg, crc: getCRC)
        
        return msgShow
    }
    
    
    func creatPINPADMSG(data msg: String, crc: UInt16) -> [UInt8] {
        let syn: UInt8 = 0x16
        let etb: UInt8 = 0x17
        let data = [UInt8](Data(msg.utf8))
        var bytes = [UInt8]()
        
        bytes.append(syn)
        
        //append msg in bytes to array
        data.forEach { (b) in
            bytes.append(b)
        }
        
        bytes.append(etb)
        
        //convert crc in UInt16 to UInt8 and append to array
        var bigEndian = crc.bigEndian
        withUnsafeBytes(of: &bigEndian) { bytes.append(contentsOf: $0)}
        
        return bytes
    }
    
    func loadTableLoadInit(input: String) -> [UInt8] {
        
        let sizeMsg = String(format: "%03d", input.count)
        
        let inputMSG = "\(PinpadCommands.tableLoadInit.rawValue)\(sizeMsg)\(input)"
        
        print("input")
        print(inputMSG)
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMSG)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgInitTable = creatPINPADMSG(data: inputMSG, crc: getCRC)
        
        print(String(bytes: msgInitTable, encoding: .ascii))

        return msgInitTable
    }
    
    func loadTableLoadRec(table: String) -> [UInt8] {
        
        let sizeMsg = String(format: "%03d", table.count)
        let inputMSG = "\(PinpadCommands.tableLoadRec.rawValue)\(sizeMsg)\(table)"

        //append ETB on message
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMSG)
        
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        return creatPINPADMSG(data: inputMSG, crc: getCRC)
    }
    
    
    func loadTableLoadEnd() -> [UInt8] {
        
        //append ETB on message
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: PinpadCommands.tableLoadEnd.rawValue)
        
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        return creatPINPADMSG(data: PinpadCommands.tableLoadEnd.rawValue, crc: getCRC)
    }
    
    func startGetCard() -> [UInt8] {
        let input = "100000000000200019021220220531122014270510011003100510061007"
        
        let sizeMsg = String(format: "%03d", input.count)
        
        let msgGetCard = "\(PinpadCommands.getCard.rawValue)\(sizeMsg)\(input)"
        
        //todo: passar msgToCRC no createPINPADMSG
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: msgGetCard)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGetCard = creatPINPADMSG(data: msgGetCard, crc: getCRC)
        
        let m: [UInt8] = [0x16, 0x47, 0x43, 0x52, 0x30, 0x36, 0x30, 0x31, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x30, 0x30, 0x30, 0x31, 0x39, 0x30, 0x32, 0x31, 0x34, 0x32, 0x30, 0x32, 0x38, 0x35, 0x34, 0x33, 0x31, 0x31, 0x32, 0x32, 0x30, 0x31, 0x34, 0x32, 0x37, 0x30, 0x35, 0x31, 0x30, 0x30, 0x31, 0x31, 0x30, 0x30, 0x33, 0x31, 0x30, 0x30, 0x35, 0x31, 0x30, 0x30, 0x36, 0x31, 0x30, 0x30, 0x37, 0x17, 0x05, 0x40]
        //return msgStartGetCard
        
        return m
    }
    
    func getCard() -> [UInt8] {
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: PinpadCommands.getCard.rawValue)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGetCard = creatPINPADMSG(data: PinpadCommands.getCard.rawValue, crc: getCRC)
        
        return msgStartGetCard
        
    }
    
    func startGoOnChip(input: String, tags: String, tagsOpt: String) -> [UInt8] {
        
        let sizeInput = String(format: "%03d", input.count)
        let sizeTags = String(format: "%03d", tags.count)
        let sizeTagsOpt = String(format: "%03d", tagsOpt.count)
        
        let inputMSG = "\(PinpadCommands.goOnChip.rawValue)\(sizeInput)\(input)\(sizeTags)\(tags)\(sizeTagsOpt)\(tagsOpt)"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMSG)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        print(getCRC)
        let msgGoOnChip = creatPINPADMSG(data: inputMSG, crc: getCRC)
        
        return msgGoOnChip
//
//        let input: [UInt8] = [0x16, 0x47, 0x4F, 0x43, 0x30, 0x38, 0x36, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x32, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x30, 0x30, 0x33, 0x30, 0x31, 0x41, 0x36, 0x34, 0x44, 0x34, 0x38, 0x34, 0x31, 0x33, 0x30, 0x42, 0x38, 0x44, 0x31, 0x33, 0x42, 0x33, 0x41, 0x30, 0x36, 0x36, 0x34, 0x37, 0x41, 0x32, 0x31, 0x37, 0x43, 0x46, 0x46, 0x31, 0x37, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x38, 0x35, 0x30, 0x34, 0x31, 0x38, 0x32, 0x38, 0x34, 0x39, 0x31, 0x39, 0x35, 0x35, 0x46, 0x32, 0x41, 0x35, 0x46, 0x33, 0x34, 0x39, 0x41, 0x39, 0x43, 0x39, 0x46, 0x30, 0x32, 0x39, 0x46, 0x30, 0x33, 0x39, 0x46, 0x30, 0x39, 0x39, 0x46, 0x31, 0x30, 0x39, 0x46, 0x31, 0x41, 0x39, 0x46, 0x31, 0x45, 0x39, 0x46, 0x32, 0x36, 0x39, 0x46, 0x32, 0x37, 0x39, 0x46, 0x33, 0x33, 0x39, 0x46, 0x33, 0x34, 0x39, 0x46, 0x33, 0x35, 0x39, 0x46, 0x33, 0x36, 0x39, 0x46, 0x33, 0x37, 0x39, 0x46, 0x34, 0x31, 0x39, 0x42, 0x39, 0x46, 0x36, 0x45, 0x30, 0x30, 0x33, 0x30, 0x30, 0x30, 0x17, 0x7A, 0xB0]
//
//        return input
        
    }
    
    
    func goOnChip(input: String) -> [UInt8] {
        
        let sizeMsg = String(format: "%03d", input.count)
        let msgGoOnChip = "\(PinpadCommands.goOnChip.rawValue)\(input)"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: msgGoOnChip)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGoOnChip = creatPINPADMSG(data: msgGoOnChip, crc: getCRC)
    
        print(String(bytes: msgStartGoOnChip, encoding: .ascii))
    
        return msgStartGoOnChip
//        let m: [UInt8] = [0x16, 0x47, 0x4F, 0x43, 0x30, 0x38, 0x36, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x30, 0x30, 0x33, 0x30, 0x31, 0x41, 0x36, 0x34, 0x44, 0x34, 0x38, 0x34, 0x31, 0x33, 0x30, 0x42, 0x38, 0x44, 0x31, 0x33, 0x42, 0x33, 0x41, 0x30, 0x36, 0x36, 0x34, 0x37, 0x41, 0x32, 0x31, 0x37, 0x43, 0x46, 0x46, 0x31, 0x37, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x38, 0x35, 0x30, 0x34, 0x31, 0x38, 0x32, 0x38, 0x34, 0x39, 0x31, 0x39, 0x35, 0x35, 0x46, 0x32, 0x41, 0x35, 0x46, 0x33, 0x34, 0x39, 0x41, 0x39, 0x43, 0x39, 0x46, 0x30, 0x32, 0x39, 0x46, 0x30, 0x33, 0x39, 0x46, 0x30, 0x39, 0x39, 0x46, 0x31, 0x30, 0x39, 0x46, 0x31, 0x41, 0x39, 0x46, 0x31, 0x45, 0x39, 0x46, 0x32, 0x36, 0x39, 0x46, 0x32, 0x37, 0x39, 0x46, 0x33, 0x33, 0x39, 0x46, 0x33, 0x34, 0x39, 0x46, 0x33, 0x35, 0x39, 0x46, 0x33, 0x36, 0x39, 0x46, 0x33, 0x37, 0x39, 0x46, 0x34, 0x31, 0x39, 0x42, 0x39, 0x46, 0x36, 0x45, 0x30, 0x30, 0x33, 0x30, 0x30, 0x30, 0x17, 0x23, 0x75]
//
//        let mSTR = String(bytes: m, encoding: .ascii)
//        print(mSTR)
//        return m
    }
    
    func getTimeStampt(input: String) -> [UInt8] {
       
        let sizeMsg = String(format: "%03d", input.count)
        let inputMsg = "GTS00210"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMsg)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGetCard = creatPINPADMSG(data: inputMsg, crc: getCRC)
        
        return msgStartGetCard
    }
}
