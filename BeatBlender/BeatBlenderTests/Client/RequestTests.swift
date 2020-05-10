import Foundation
import XCTest

@testable import BeatBlender

class RequestTests: XCTestCase {
	func testStringfy() throws {
		let beatBlenderRequest = BeatBlenderRequest(numSamples: 1, temperature: 0.5)
		
		let expectedJsonString: String = "{\"numSamples\":1,\"temperature\":0.5}"
		
		let jsonString = beatBlenderRequest.stringify()
		XCTAssertEqual(jsonString, expectedJsonString)
	}
}
