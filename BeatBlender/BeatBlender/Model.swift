import Foundation

class NoteSequenceModel {
    let beatBlenderRequest: BeatBlenderRequest

    init(baseUrl: String) {
        beatBlenderRequest = BeatBlenderRequest(baseUrl: baseUrl)
    }

    func sample() {}

    func interpolate() {}
}
