//
//  Pinpad.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 11/02/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation



enum StatusDeviceMessage {
    case beginning
    case middle
    case end
}

enum ResponseCodeBC: String{
    case pp_ok          = "000"
    case pp_processing  = "001"
    case pp_notify      = "002"
    case pp_cancel      = "013"

    static func getFromString(code: String?) -> ResponseCodeBC? {
        if let code = code, let responseCode = ResponseCodeBC.init(rawValue: code) {
            return responseCode
        } else {
            return nil
        }
    }
}

struct BCBuildMessages {

    
    func open() -> [UInt8]{
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: PinpadCommands.open.rawValue)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgOpen = creatPINPADMSG(data: PinpadCommands.open.rawValue, crc: getCRC)
        
        return msgOpen
    }
    
    func getInfo(input: String) -> [UInt8] {
        let sizeMsg = String(format: "%03d", input.count)

        let inputMSG = "\(PinpadCommands.getInfo.rawValue)\(sizeMsg)\(input)"
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMSG)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgGetInfo = creatPINPADMSG(data: inputMSG, crc: getCRC)
    
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
    
    func startGetCard(input: String) -> [UInt8] {
        
        let sizeMsg = String(format: "%03d", input.count)
        let msgGetCard = "\(PinpadCommands.getCard.rawValue)\(sizeMsg)\(input)"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: msgGetCard)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGetCard = creatPINPADMSG(data: msgGetCard, crc: getCRC)
        
        return msgStartGetCard
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
        
        let msgGoOnChip = creatPINPADMSG(data: inputMSG, crc: getCRC)
        
        return msgGoOnChip
    }
    
    
    func goOnChip(input: String) -> [UInt8] {
        
        let sizeMsg = String(format: "%03d", input.count)
        let msgGoOnChip = "\(PinpadCommands.goOnChip.rawValue)\(input)"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: msgGoOnChip)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGoOnChip = creatPINPADMSG(data: msgGoOnChip, crc: getCRC)
    
        return msgStartGoOnChip
    }
    
    func getTimeStampt(input: String) -> [UInt8] {
       
        let sizeMsg = String(format: "%03d", input.count)
        let inputMsg = "GTS00210"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMsg)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
        let msgStartGetCard = creatPINPADMSG(data: inputMsg, crc: getCRC)
        
        return msgStartGetCard
    }
    
    func finishChip(input: String, inputTags: String) -> [UInt8] {
        
        let inputSize = String(format: "%03d", input.count)
        let tagsSize = String(format: "%03d", inputTags.count)
        
        let inputMSG = "\(PinpadCommands.finishChip.rawValue)\(inputSize)\(input)\(tagsSize)\(inputTags)"
        
        let msgToCRC = CalculoCRC().prepareDataToCRC(ppFunc: inputMSG)
        let getCRC = CalculoCRC().crcXModem(bytes: msgToCRC)
    
        let msgFinishiChip = creatPINPADMSG(data: inputMSG, crc: getCRC)
        
        return msgFinishiChip
    }

    func readMessage(data: Data, lastFunc: PinpadCommands? = nil) -> ResponseBC  {

        var bytes = [UInt8](data)
        let nak: UInt8 = 0x15
        let initMSG: UInt8 = 0x16
        let last: UInt8 = 0x17
        
        var firstByte = bytes[0]
        var function = [UInt8]()
        var statusMSG: StatusDeviceMessage

        var crc = [UInt8]()
        
        var responseCodeByte = [UInt8]()
        
        let okByte: UInt8 = 0x06

        if bytes.count < 2 {
            if firstByte == okByte {
                
                let message = String(data: data, encoding: .ascii)!
                let response = ResponseBC(resposeCode: .pp_ok, function: .close, statusMessage: .end, sizeMessage: "000", message: message)
                return response
                
            }  else {
                //nak (bit 15)
                let message = String(data: data, encoding: .ascii)!
                let response = ResponseBC(resposeCode: .pp_ok, function: .nak, statusMessage: .end, sizeMessage: "000", message: message)
                return response
            }
        }
        

        if firstByte == okByte {
            
            //ignore okbyte on first position
            firstByte = bytes[1]
            
            if firstByte == initMSG {
                
                function.append(bytes[2])
                function.append(bytes[3])
                function.append(bytes[4])
                
                bytes.removeFirst(5)
                statusMSG = .beginning
                
                responseCodeByte.append(bytes[0])
                responseCodeByte.append(bytes[1])
                responseCodeByte.append(bytes[2])
                
                //remove responseCode
                bytes.removeFirst(3)
            } else {
                
//                function.append(bytes[1])
//                function.append(bytes[2])
//                function.append(bytes[3])
//
//                bytes.removeFirst(4)
                statusMSG = .middle
            }
            

        } else {
            
            if firstByte == initMSG {
                
                function.append(bytes[1])
                function.append(bytes[2])
                function.append(bytes[3])
                
                bytes.removeFirst(4)
                statusMSG = .beginning
                
                responseCodeByte.append(bytes[0])
                responseCodeByte.append(bytes[1])
                responseCodeByte.append(bytes[2])
                
                //remove responseCode
                bytes.removeFirst(3)
                
            } else {
                
//                function.append(bytes[0])
//                function.append(bytes[1])
//                function.append(bytes[2])
//
//                bytes.removeFirst(3)
                statusMSG = .middle
            }
            
        }

        
        var lastByte: UInt8 = bytes[bytes.count - 3]
        
        if lastByte == last {
            crc.append(bytes[bytes.count - 2])
            crc.append(bytes[bytes.count - 1])
            
            //remove crc from msg
            bytes.removeLast(3)
            statusMSG = .end
        }
        
        
        let codeStr = String(bytes: responseCodeByte, encoding: .ascii)
        
        let responseCode = ResponseCodeBC.getFromString(code: codeStr)
        print(responseCode)
        
//        switch responseCode {
//        case .pp_ok: print("OK")
//
//        default: do {
//            print(responseCode)
////            let message = String(bytes: bytes, encoding: .ascii)!
////            let response = ResponseBC(resposeCode: .pp_ok, function: .close, statusMessage: .end, sizeMessage: "000", message: message)
////            return response
//
//            }
//
//        }
        
        guard let rCode = responseCode else {
            let message = String(bytes: bytes, encoding: .ascii)!
            let response = ResponseBC(resposeCode: nil, function: lastFunc, statusMessage: statusMSG, sizeMessage: "000", message: message)
            return response
        }
        
        
        let bcCommnad = getBCFunction(function: Data(function))
        
       
        
        var size = "000"
        
        if bytes.count > 3 {
            var inputSize = [UInt8]()
            inputSize.append(bytes[0])
            inputSize.append(bytes[1])
            inputSize.append(bytes[2])
            
            //remove inputSize
            bytes.removeFirst(3)
            
            size  = String(bytes: inputSize, encoding: .ascii)!
        }
        
        let message = String(bytes: bytes, encoding: .ascii)!
        let response = ResponseBC(resposeCode: rCode, function: bcCommnad, statusMessage: statusMSG, sizeMessage: size, message: message)
        return response
    
        
    }

    func getBCFunction(function: Data) -> PinpadCommands {
        let strFunc = String(data: function, encoding: .ascii)
        return PinpadCommands.getFromString(function: strFunc)
    }
    
    func getResponseCodeBC(buffer: [UInt8]) -> ResponseCodeBC? {
        let str = String(bytes: buffer, encoding: .ascii)
        return ResponseCodeBC.getFromString(code: str)
    }
}


struct ReadBCMessages {
    func getInfoPinpad(msg: String) -> GetInfo {
        
        if msg.count == 100 {
            return getInfoGeneral(input: msg)
        } else {
            return getInfoAcquirer(input: msg)
        }
    }
    
    func getInfoGeneral(input: String) -> GetInfoGeneral{
        let manufactor = input.substring(fromIndex: 0, toIndex: 20)
        let model = input.substring(fromIndex: 21, toIndex: 39)
        
        var contactless: Bool {
            if input.getChar(at: 39).elementsEqual("C") {
                return true
            }
            return false
        }
        
        let firmwareVersion = input.substring(fromIndex: 40, toIndex: 60)
        let especification = input.substring(fromIndex: 60, toIndex: 64)
        let applicationVersion = input.substring(fromIndex: 64, toIndex: 80)
        let serialNumber = input.substring(fromIndex: 80, toIndex: input.count - 1)
        
        return GetInfoGeneral(applicationVersion: applicationVersion, manufacturer: manufactor, model: model, contactlessSupport: contactless, firmwareVersion: firmwareVersion, especificationVersion: especification, serialNumber: serialNumber)
    }
    
    func getInfoAcquirer(input: String) -> GetInfoAcquirer {
        let acquirer = input.substring(fromIndex: 0, toIndex: 20)
        let applicationVersion = input.substring(fromIndex: 20, toIndex: 33)
        let acquirerInfo = input.substring(fromIndex: 33, toIndex: 40)
        let idSAMSize = input.substring(fromIndex: 40, toIndex: 42)
        let idSAM = input.substring(fromIndex: 42, toIndex: input.count - 1)
        return GetInfoAcquirer(applicationVersion: applicationVersion, acquirer: acquirer, acquirerInfo: acquirerInfo, idSAMSize: idSAMSize, idSAM: idSAM)
        
    }
    
    func readGoOnChip(output: String) {
        
        let str = output
        let decision = output.substring(fromIndex: 0, toIndex: 1)
        let needAsign = output.substring(fromIndex: 1, toIndex: 2)
        let pinVerifiedOff = output.substring(fromIndex: 2, toIndex: 3)
        let pinNumberValidAppearsOff = output.substring(fromIndex: 3, toIndex: 4)
        let pinOffBloquedLastAppear = output.substring(fromIndex: 4, toIndex: 5)
        let pinToVerifyOn = output.substring(fromIndex: 5, toIndex: 6)
        var encryptedPin: String? = nil
        var keySerialNumber: String? = nil
        
        if pinToVerifyOn == "1" {
            encryptedPin = output.substring(fromIndex: 6, toIndex: 22)
            keySerialNumber = output.substring(fromIndex: 22, toIndex: 42)
        }
        
        let isoFieldSize = output.substring(fromIndex: 42, toIndex: 45)
        var emvTags: String?
        var sizeDataAquirer: String
        var dataAquirer: String?
        if let emvTagsSize = Int(isoFieldSize), emvTagsSize > 0 {
            emvTags = output.substring(fromIndex: 45, toIndex: emvTagsSize + 45)
            sizeDataAquirer = output.substring(fromIndex: emvTagsSize + 45, toIndex: emvTagsSize + 45 + 3 )
            
            if let sizeDataAquirerInt = Int(sizeDataAquirer) {
                dataAquirer = output.substring(fromIndex: emvTagsSize + 45 + 3, toIndex: emvTagsSize + 45 + 3 + sizeDataAquirerInt )
            }
            
        } else {
            
            sizeDataAquirer = output.substring(fromIndex: 48, toIndex:  48 + 3 )
            
            if let sizeDataAquirerInt = Int(sizeDataAquirer) {
                dataAquirer = output.substring(fromIndex: 48 + 3, toIndex: 48 + 3 + sizeDataAquirerInt )
            }
        }
        
        
    }
}


struct ResponseBC {
    let resposeCode: ResponseCodeBC?
    let function: PinpadCommands?
    let statusMessage: StatusDeviceMessage
    let sizeMessage: String
    let message: String
}
