
import Foundation
struct AidTable : Codable {
	let aidTableRegistry : AidTableRegistry?

	enum CodingKeys: String, CodingKey {

		case aidTableRegistry = "aidTableRegistry"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		aidTableRegistry = try values.decodeIfPresent(AidTableRegistry.self, forKey: .aidTableRegistry)
	}

}
