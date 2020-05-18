import AVFoundation
import Foundation

extension Tensorflow_Magenta_NoteSequence {
    func toMusicSequence() -> MusicSequence? {
        var musicSequence: MusicSequence?
        var status = NewMusicSequence(&musicSequence)
        guard status == OSStatus(noErr) else {
            print("[\(status)] Error: could not convert Notes to MusicSequence")
            return nil
        }

        var track: MusicTrack?
        status = MusicSequenceNewTrack(musicSequence!, &track)
        guard status == OSStatus(noErr) else {
            print("[\(status)] Error: could not create MusicTrack from MusicSequence")
            return nil
        }

        var timeStampInSeconds: Float64 = 0
        for note in notes {
            print(note)
            let duration = note.endTime - note.startTime
            var message = MIDINoteMessage(
                channel: 10,
                note: UInt8(note.pitch),
                velocity: 64,
                releaseVelocity: 0,
                duration: Float32(duration)
            )
            timeStampInSeconds += duration
            let timeStamp = MusicTimeStamp(timeStampInSeconds)
            status = MusicTrackNewMIDINoteEvent(track!, timeStamp, &message)
            if status != OSStatus(noErr) {
                print("[\(status)] Error: could not create MIDINoteEvent")
            }
        }
        return musicSequence
    }
}
