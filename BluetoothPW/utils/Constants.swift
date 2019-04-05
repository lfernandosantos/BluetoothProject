//
//  Constants.swift
//  BluetoothPW
//
//  Created by Luiz Fernando on 02/04/19.
//  Copyright © 2019 LFSantos. All rights reserved.
//

import Foundation

enum Common {
    enum AcquirerID: String {
        case all        = "00"
        case global     = "02"
        case clearent   = "10"
    }
}

enum ApplicationType: String {
    case credito    = "CREDIT"
    case debito     = "DEBIT"
    
    func getInputValue() -> String {
        switch self {
        case .credito:
            return "01"
        case .debito:
            return "02"
        }
    }
}


enum MTIValue: String {
    case initialization = "2804"
}


enum ProcessingCode: String {
    case initialization = "900000"
    case others         = "900001"
}


enum CTLSZeroAmount: String {
    case unSupported            = "UNSUPPORTED"
    case onlineOnlySupported    = "ONLINE_ONLY_SUPPORT"
    
    func getInputValue() -> String {
        switch self {
        case .unSupported:
            return "0"
        case .onlineOnlySupported:
            return "1"
        }
    }
}

enum CTLSMode: String {
    case unSupported            = "UNSUPPORTED"
    case visaMSD                = "VISA_MSD_SUPPORT"
    case visaQVSDC              = "VISA_QVSDC_SUPPORT"
    case masterPayPassMagStripe = "MASTERCARD_PAYPASS_MAGNETIC_STRIPE_SUPPORT"
    case masterPayPassMagChip   = "MASTERCARD_PAYPASS_CHIP_SUPPORT"
    case amexExpresspayMagStripe = "AMEX_EXPRESSPAY_MAGNETIC_STRIPE_SUPPORT"
    case amexExpressPayEMV      = "AMEX_EXPRESSPAY_EMV_SUPPORT"
    case eloAndPure             = "ELO_AND_PURE_SUPPORT"
    case dPasMagStrip           = "D_PAS_MAGNETIC_STRIPE_SUPPORT"
    case dPassEMV               = "D_PAS_EMV_SUPPORT"
    
    func getInputValue() -> String {
        switch self {
        case .unSupported:
            return "0"
        case .visaMSD:
            return "1"
        case .visaQVSDC:
            return "2"
        case .masterPayPassMagStripe:
            return "3"
        case .masterPayPassMagChip:
            return "4"
        case .amexExpresspayMagStripe:
            return "5"
        case .amexExpressPayEMV:
            return "6"
        case .eloAndPure:
            return "7"
        case .dPasMagStrip:
            return "8"
        case .dPassEMV:
            return "9"
        }
    }
    
}


