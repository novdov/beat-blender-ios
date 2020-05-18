import Foundation

func samplesToNoteSequences(samplesArray: [Any]) -> [Tensorflow_Magenta_NoteSequence]? {
    var noteSequences = [Tensorflow_Magenta_NoteSequence]()

    for sample in samplesArray {
        guard let jsonString: String = stringifyJson(withJSONObject: sample as! [String: Any]) else {
            return nil
        }
        guard let noteSequence: Tensorflow_Magenta_NoteSequence = jsonToNoteSequence(jsonString: jsonString) else {
            return nil
        }
        noteSequences.append(noteSequence)
    }
    return noteSequences
}

func jsonToNoteSequence(jsonString: String) -> Tensorflow_Magenta_NoteSequence? {
    guard let noteSequence = try? Tensorflow_Magenta_NoteSequence(jsonString: jsonString) else {
        return nil
    }
    return noteSequence
}

func stringifyJson(withJSONObject dict: [String: Any]) -> String? {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
        return nil
    }
    let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
    return jsonString
}

func loadJson(filename _: String) -> [String: Any]? {
    guard let file = Bundle.main.url(forResource: "config", withExtension: "json") else {
        return nil
    }
    guard let data = try? Data(contentsOf: file) else { return nil }
    let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    return jsonData
}
