import AVFoundation
import Foundation

struct MIDIPlayerHelper {
    let soundFontFilename = "FluidR3_GM"
    let defaultResolution: Int16 = 480

    func createAVMIDIPlayer(withData midiData: Data) -> AVMIDIPlayer? {
        guard let url = Bundle.main.url(forResource: soundFontFilename, withExtension: "sf2") else {
            print("Error: could not load sound font - \(soundFontFilename)")
            return nil
        }

        var midiPlayer: AVMIDIPlayer?
        do {
            midiPlayer = try AVMIDIPlayer(data: midiData, soundBankURL: url)
            midiPlayer?.prepareToPlay()
            return midiPlayer
        } catch {
            print("Error: could not create AVMIDIPlayer. \(error.localizedDescription)")
            return nil
        }
    }

    func musicSequenceToData(_ musicSequence: MusicSequence) -> Unmanaged<CFData>? {
        var data: Unmanaged<CFData>?
        let status = MusicSequenceFileCreateData(
            musicSequence, .midiType, .eraseFile, defaultResolution, &data
        )

        guard status == OSStatus(noErr) else {
            print("Error: could not convert MusicSequence to data")
            return nil
        }
        return data
    }
}

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

        for note in notes {
            var message = MIDINoteMessage(
                channel: 10,
                note: UInt8(note.pitch),
                velocity: UInt8(note.velocity),
                releaseVelocity: 0,
                duration: Float32(note.endTime - note.startTime)
            )
            let timeStamp = MusicTimeStamp(1.0)
            status = MusicTrackNewMIDINoteEvent(track!, timeStamp, &message)
            if status != OSStatus(noErr) {
                print("[\(status)] Error: could not create MIDINoteEvent")
            }
        }
        return musicSequence
    }
}
