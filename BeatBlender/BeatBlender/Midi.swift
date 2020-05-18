import AVFoundation
import Foundation

struct MIDIPlayerHelper {
    let soundFontFilename = "1115-Standard Rock Set"
    let defaultResolution: Int16 = 480

    func createAVMIDIPlayer(withData midiData: Data) -> AVMIDIPlayer? {
        guard let url = Bundle.main.url(forResource: soundFontFilename, withExtension: "sf2") else {
            print("Error: could not load \(soundFontFilename)")
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
