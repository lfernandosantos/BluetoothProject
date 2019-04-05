
import Foundation
struct AidTableRegistry : Codable {
	let authorizerId : Int?
	let contactlessCvmLimit : String?
	let contactlessApplicationVersion : String?
	let aidCode : Int?
	let targetPercentage : Int?
	let cardBrandName : String?
	let contactlessDefaultTac : String?
	let transactionCategoryCode : String?
	let maxTargetPercentage : Int?
	let contactlessAuthorizationResponseCode : String?
	let contactlessDenialTac : String?
	let floorLimit : String?
	let currencyExponent : Int?
	let contactlessZeroAmount : String?
	let contactlessMode : String?
	let denialTac : String?
	let contactlessFloorLimit : String?
	let productType : String?
	let defaultTac : String?
	let thresholdValue : Int?
	let contactlessTransactionLimit : String?
	let contactlessTerminalCapabilities : String?
	let contactlessAdditionalTerminalCapabilities : String?
	let mobileCvm : String?
	let terminalType : Int?
	let additionalTerminalCapabilities : String?
	let authorizationResponseCode : String?
	let ddol : String?
	let contactlessOnlineTac : String?
	let terminalCapabilities : String?
	let onlineTac : String?
	let emvTags : EmvTags?
	let tdol : String?
	let aidVersion3 : String?
	let contactlessSelectionMode : Int?
	let aid : String?
	let aidVersion2 : String?
	let currencyCode : Int?
	let aidVersion1 : String?

	enum CodingKeys: String, CodingKey {

		case authorizerId = "authorizerId"
		case contactlessCvmLimit = "contactlessCvmLimit"
		case contactlessApplicationVersion = "contactlessApplicationVersion"
		case aidCode = "aidCode"
		case targetPercentage = "targetPercentage"
		case cardBrandName = "cardBrandName"
		case contactlessDefaultTac = "contactlessDefaultTac"
		case transactionCategoryCode = "transactionCategoryCode"
		case maxTargetPercentage = "maxTargetPercentage"
		case contactlessAuthorizationResponseCode = "contactlessAuthorizationResponseCode"
		case contactlessDenialTac = "contactlessDenialTac"
		case floorLimit = "floorLimit"
		case currencyExponent = "currencyExponent"
		case contactlessZeroAmount = "contactlessZeroAmount"
		case contactlessMode = "contactlessMode"
		case denialTac = "denialTac"
		case contactlessFloorLimit = "contactlessFloorLimit"
		case productType = "productType"
		case defaultTac = "defaultTac"
		case thresholdValue = "thresholdValue"
		case contactlessTransactionLimit = "contactlessTransactionLimit"
		case contactlessTerminalCapabilities = "contactlessTerminalCapabilities"
		case contactlessAdditionalTerminalCapabilities = "contactlessAdditionalTerminalCapabilities"
		case mobileCvm = "mobileCvm"
		case terminalType = "terminalType"
		case additionalTerminalCapabilities = "additionalTerminalCapabilities"
		case authorizationResponseCode = "authorizationResponseCode"
		case ddol = "ddol"
		case contactlessOnlineTac = "contactlessOnlineTac"
		case terminalCapabilities = "terminalCapabilities"
		case onlineTac = "onlineTac"
		case emvTags = "emvTags"
		case tdol = "tdol"
		case aidVersion3 = "aidVersion3"
		case contactlessSelectionMode = "contactlessSelectionMode"
		case aid = "aid"
		case aidVersion2 = "aidVersion2"
		case currencyCode = "currencyCode"
		case aidVersion1 = "aidVersion1"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		authorizerId = try values.decodeIfPresent(Int.self, forKey: .authorizerId)
		contactlessCvmLimit = try values.decodeIfPresent(String.self, forKey: .contactlessCvmLimit)
		contactlessApplicationVersion = try values.decodeIfPresent(String.self, forKey: .contactlessApplicationVersion)
		aidCode = try values.decodeIfPresent(Int.self, forKey: .aidCode)
		targetPercentage = try values.decodeIfPresent(Int.self, forKey: .targetPercentage)
		cardBrandName = try values.decodeIfPresent(String.self, forKey: .cardBrandName)
		contactlessDefaultTac = try values.decodeIfPresent(String.self, forKey: .contactlessDefaultTac)
		transactionCategoryCode = try values.decodeIfPresent(String.self, forKey: .transactionCategoryCode)
		maxTargetPercentage = try values.decodeIfPresent(Int.self, forKey: .maxTargetPercentage)
		contactlessAuthorizationResponseCode = try values.decodeIfPresent(String.self, forKey: .contactlessAuthorizationResponseCode)
		contactlessDenialTac = try values.decodeIfPresent(String.self, forKey: .contactlessDenialTac)
		floorLimit = try values.decodeIfPresent(String.self, forKey: .floorLimit)
		currencyExponent = try values.decodeIfPresent(Int.self, forKey: .currencyExponent)
		contactlessZeroAmount = try values.decodeIfPresent(String.self, forKey: .contactlessZeroAmount)
		contactlessMode = try values.decodeIfPresent(String.self, forKey: .contactlessMode)
		denialTac = try values.decodeIfPresent(String.self, forKey: .denialTac)
		contactlessFloorLimit = try values.decodeIfPresent(String.self, forKey: .contactlessFloorLimit)
		productType = try values.decodeIfPresent(String.self, forKey: .productType)
		defaultTac = try values.decodeIfPresent(String.self, forKey: .defaultTac)
		thresholdValue = try values.decodeIfPresent(Int.self, forKey: .thresholdValue)
		contactlessTransactionLimit = try values.decodeIfPresent(String.self, forKey: .contactlessTransactionLimit)
		contactlessTerminalCapabilities = try values.decodeIfPresent(String.self, forKey: .contactlessTerminalCapabilities)
		contactlessAdditionalTerminalCapabilities = try values.decodeIfPresent(String.self, forKey: .contactlessAdditionalTerminalCapabilities)
		mobileCvm = try values.decodeIfPresent(String.self, forKey: .mobileCvm)
		terminalType = try values.decodeIfPresent(Int.self, forKey: .terminalType)
		additionalTerminalCapabilities = try values.decodeIfPresent(String.self, forKey: .additionalTerminalCapabilities)
		authorizationResponseCode = try values.decodeIfPresent(String.self, forKey: .authorizationResponseCode)
		ddol = try values.decodeIfPresent(String.self, forKey: .ddol)
		contactlessOnlineTac = try values.decodeIfPresent(String.self, forKey: .contactlessOnlineTac)
		terminalCapabilities = try values.decodeIfPresent(String.self, forKey: .terminalCapabilities)
		onlineTac = try values.decodeIfPresent(String.self, forKey: .onlineTac)
		emvTags = try values.decodeIfPresent(EmvTags.self, forKey: .emvTags)
		tdol = try values.decodeIfPresent(String.self, forKey: .tdol)
		aidVersion3 = try values.decodeIfPresent(String.self, forKey: .aidVersion3)
		contactlessSelectionMode = try values.decodeIfPresent(Int.self, forKey: .contactlessSelectionMode)
		aid = try values.decodeIfPresent(String.self, forKey: .aid)
		aidVersion2 = try values.decodeIfPresent(String.self, forKey: .aidVersion2)
		currencyCode = try values.decodeIfPresent(Int.self, forKey: .currencyCode)
		aidVersion1 = try values.decodeIfPresent(String.self, forKey: .aidVersion1)
	}
    
    func getApplicationType() -> ApplicationType? {
        return ApplicationType(rawValue: productType ?? "CREDIT")
    }    

    func getInputTable(acquirerID: String, countryCode: Int, merchandID: Int, merchantCategoryCode: Int, terminalID: String) -> String {
        
        var input: String = "1"
        input += acquirerID
        input += String(format: "%02d", aidCode ?? 0)
        input += getSizeInBytes(size: aid?.count ?? 0)
        input += String(aid ?? " ").padding(toLength: 32, withPad: "0", startingAt: 0)
        input += ApplicationType(rawValue: productType ?? "CREDIT")?.getInputValue() ?? "CREDIT"
        input += String(cardBrandName ?? " ").padding(toLength: 16, withPad: " ", startingAt: 0)
        input += "03"
        input += aidVersion1 ?? "0000"
        input += aidVersion2 ?? "0000"
        input += aidVersion3 ?? "0000"
        input += String(format: "%03d", countryCode)
        input += String(format: "%03d", currencyCode ?? 0)
        input += String(currencyExponent ?? 0)
        input += String(format: "%015d", merchandID)
        input += String(format: "%04d", merchantCategoryCode)
        input += terminalID
        input += terminalCapabilities ?? "000000"
        input += additionalTerminalCapabilities ?? "0000000000"
        input += String(format: "%02d", terminalType ?? 0)
        input += defaultTac ?? "0000000000"
        input += denialTac ?? "0000000000"
        input += onlineTac ?? "0000000000"
        input += floorLimit ?? "00000000"
        input += transactionCategoryCode ?? " "
        input += CTLSZeroAmount(rawValue: contactlessZeroAmount ?? "0")?.getInputValue() ?? "0"
        input += CTLSMode(rawValue: contactlessMode ?? "UNSUPPORTED")?.getInputValue() ?? "0"
        input += contactlessTransactionLimit ?? "00000000"
        input += contactlessFloorLimit ?? "00000000"
        input += contactlessCvmLimit ?? "00000000"
        input += contactlessApplicationVersion ?? "0000"
        input += String(contactlessSelectionMode ?? 0)
        input += tdol ?? "0000000000000000000000000000000000000000"
        input += ddol ?? "0000000000000000000000000000000000000000"
        input += "Y1Z1Y3Z3"
        input += contactlessDefaultTac ?? "0000000000"
        input += contactlessDenialTac ?? "0000000000"
        input += contactlessOnlineTac ?? "0000000000"
        
        let inputSize = String(format: "%02d", input.count)
        
        
        return "01" + inputSize + input
    }
    
    func getSizeInBytes(size: Int) -> String {
    
        var sizeBye: Int = 0
        if size > 0 {
            if size % 2 == 0 {
                sizeBye = (size / 2)
            } else {
                sizeBye = (size + 1)/2
            }
        }
        
        return String(format: "%02d", sizeBye )
        
    }

}
