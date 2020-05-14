import Foundation

class NoteSequenceModel {
	let beatBlenderRequest: BeatBlenderRequest

	init(baseUrl: String) {
		self.beatBlenderRequest = BeatBlenderRequest(baseUrl: baseUrl)
	}

	func sample() {}

	func interpolate() {}
}
