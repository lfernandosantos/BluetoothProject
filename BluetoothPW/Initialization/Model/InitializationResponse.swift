

import Foundation

struct InitializationResponseData : Codable {
    let initialization : Initialization?
    
    enum CodingKeys: String, CodingKey {
        
        case initialization = "initializationResponse"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        initialization = try values.decodeIfPresent(Initialization.self, forKey: .initialization)
    }
    
    static func decode(from data: Data) -> InitializationResponseData? {
        if let decodedObject = try? JSONDecoder().decode(InitializationResponseData.self, from: data) {
            return decodedObject
        }
        return nil
    }
}


struct Initialization : Codable {
    let aidTable : [AidTable]?
    
    enum CodingKeys: String, CodingKey {
        
        case aidTable = "aidTable"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aidTable = try values.decodeIfPresent([AidTable].self, forKey: .aidTable)
    }
    
}

