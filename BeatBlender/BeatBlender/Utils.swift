import Foundation

func jsonToNoteSequence(jsonString: String) -> Tensorflow_Magenta_NoteSequence? {
	guard let noteSequence = try? Tensorflow_Magenta_NoteSequence(jsonString: jsonString) else {
		return nil
	}
	return noteSequence
}

func stringifyJson(withJSONObject dict: [String:Any]) -> String? {
	guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
		return nil
	}
	let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
	return jsonString
}
