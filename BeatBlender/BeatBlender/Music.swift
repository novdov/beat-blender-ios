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

    var beat = MusicTimeStamp(0.5)
    for note in notes {
      // TODO: Use quantizedStep as time
      // Reference: https://github.com/tensorflow/magenta/blob/master/magenta/music/sequences_lib.py#L1680
      var message = MIDINoteMessage(
        channel: 10,
        note: UInt8(note.pitch),
        velocity: getRandomVelocity(),
        releaseVelocity: 0,
        duration: 0.5
      )
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
