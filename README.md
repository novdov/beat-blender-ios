# beatit-ios

Generate random drum beats using [magenta's MusicVAE](https://github.com/tensorflow/magenta/tree/master/magenta/models).

## How to Run

- To run app, you should run server first. Check out [this repo](https://github.com/novdov/beat-blender-server) (simple api written in nodejs) and run server.
- To test app in localhost, you should enable **App Transport Security Settings > Allow Arbitrary Loads** in info.plist.
- Then, write `config.json` to specify api url to request samping beats.
```json
{
  "serverUrl": "Entry point API Address (e.g.) http://localhost:PORT/model)"
 }
```

## TODO

- [ ] Add groove to beat using GrooVAE
- [ ] Convert NoteSequence protocol to MIDI Event properly
