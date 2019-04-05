

import Foundation
struct EmvTags : Codable {
	let compulsory : String?
	let compulsorySecondAc : String?
	let optionalSecondAc : String?
	let optional : String?

	enum CodingKeys: String, CodingKey {

		case compulsory = "compulsory"
		case compulsorySecondAc = "compulsorySecondAc"
		case optionalSecondAc = "optionalSecondAc"
		case optional = "optional"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		compulsory = try values.decodeIfPresent(String.self, forKey: .compulsory)
		compulsorySecondAc = try values.decodeIfPresent(String.self, forKey: .compulsorySecondAc)
		optionalSecondAc = try values.decodeIfPresent(String.self, forKey: .optionalSecondAc)
		optional = try values.decodeIfPresent(String.self, forKey: .optional)
	}

}
