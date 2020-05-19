import AVFoundation
import Foundation

let midiNoteToDrumRowMap: [Int32: Int32] = [
  36: 0,
  38: 1,
  42: 2,
  46: 3,
  45: 4,
  48: 5,
  50: 6,
  49: 7,
  51: 8,
]

let drumRowToMidiNoteMap: [Int32: Int32] = [
  0: 36,
  1: 38,
  2: 42,
  3: 46,
  4: 34,
  5: 48,
  6: 50,
  7: 49,
  8: 51,
]

struct DrumEncoderDecoder {
  func midiNoteToDrumRow(_ midiNote: Int32) -> Int32 {
    midiNoteToDrumRowMap[midiNote] ?? -1
  }

  func drumRowtoMidiNote(_ drumRow: Int32) -> Int32 {
    drumRowToMidiNoteMap[drumRow] ?? -1
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

    var beat = MusicTimeStamp(0.5)
    for note in notes {
      // Use quantizedStep as time
      // Reference: https://github.com/tensorflow/magenta/blob/master/magenta/music/sequences_lib.py#L1680
      //            let duration = note.quantizedEndStep - note.quantizedStartStep
      var message = MIDINoteMessage(
        channel: 10,
        note: UInt8(note.pitch),
        velocity: getRandomVelocity(),
        releaseVelocity: 0,
        duration: 0.5
      )
      //            let timeStampInSeconds = Float64(note.quantizedStartStep)
      status = MusicTrackNewMIDINoteEvent(track!, beat, &message)
      if status != OSStatus(noErr) {
        print("[\(status)] Error: could not create MIDINoteEvent")
      }
      beat += 0.5
    }
    return musicSequence
  }
}

func getRandomVelocity() -> UInt8 {
  UInt8.random(in: 64...74)
}
