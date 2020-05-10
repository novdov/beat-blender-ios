import Foundation

protocol BeatBlenderCodable: Codable {
    func stringify() -> String?
}

struct BeatBlenderRequest: BeatBlenderCodable {
    let numSamples: Int?
    let temperature: Float64?
	
	/// Encode and stringify `BeatBlenderCodable` protocol
	/// - Returns: Strinified json data.
	func stringify() -> String? {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        if let encoded = encoded, let jsonString = String(data: encoded, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
}
