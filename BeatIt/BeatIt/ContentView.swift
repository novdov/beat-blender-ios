import AVFoundation
import SwiftUI

let config = loadJson(filename: "config")!

struct ContentView: View {
  let spliceRequest = BeatBlenderRequest(baseUrl: config["serverUrl"] as! String)
  var midiPlayerHelper = MIDIPlayerHelper()
  @State var played = false
  @State var midiPlayer: AVMIDIPlayer?
  @State var buttonText = "Beat It!"
  @State var mediaButtonName = "play.fill"

  var body: some View {
    Button(action: {
      self.buttonText = self.played ? self.buttonText : "Stop"
      self.mediaButtonName = self.played ? self.mediaButtonName : "pause.fill"
      self.sample()
    }) {
      HStack {
        Image(systemName: self.mediaButtonName)
        Text(self.buttonText)
      }
    }.buttonStyle(GradientButtonStyle())
  }

  func playDrums(noteSequence: Tensorflow_Magenta_NoteSequence) {
    guard let musicSequence = noteSequence.toMusicSequence(),
      let data = midiPlayerHelper.musicSequenceToData(musicSequence)
    else {
      return
    }
    let midiData = data.takeUnretainedValue() as Data
    midiPlayer = midiPlayerHelper.createAVMIDIPlayer(withData: midiData)
    data.release()
    self.played = true
    midiPlayer?.play()
  }

  func sample() {
    let body = BeatBlenderRequestBody(numSamples: 1, temperature: 0.5)
    spliceRequest.post(
      endpoint: "/sample", requestBody: body,
      completion: { result in
        switch result {
        case let .success(sampleData):
          let samplesArray = sampleData["samples"] as! [Any]
          guard
            let noteSequences: [Tensorflow_Magenta_NoteSequence] = samplesToNoteSequences(
              samplesArray: samplesArray)
          else {
            return
          }
          for noteSequence in noteSequences {
            self.playDrums(noteSequence: noteSequence)
            self.played = false
          }
        case let .failure(error):
          print(error)
        }
      })
  }
}

struct GradientButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(Color.white)
      .padding()
      .background(
        LinearGradient(
          gradient: Gradient(colors: [Color.red, Color.orange]),
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .cornerRadius(15.0)
      .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
