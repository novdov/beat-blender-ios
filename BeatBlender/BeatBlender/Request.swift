import Foundation

enum APIError: Error {
    case responseError
    case encodingError
    case decodingError
}

struct BeatBlenderRequestBody: Codable {
    let numSamples: Int
    let temperature: Float64
}

struct BeatBlenderRequest {
    var session: URLSession = URLSession.shared
    let baseUrl: String

    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    private func getUrlRequest(endpoint: String) -> URLRequest {
        let url = baseUrl + endpoint
        guard let requestUrl = URL(string: url) else { fatalError() }
        let request = URLRequest(url: requestUrl)
        return request
    }

    func post(
        endpoint: String,
        requestBody: BeatBlenderRequestBody,
        completion: @escaping (Result<Tensorflow_Magenta_NoteSequence, APIError>) -> Void
    ) {
        var request = getUrlRequest(endpoint: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let encodedHttpBody = try? JSONEncoder().encode(requestBody) else {
            completion(.failure(.encodingError))
            return
        }
        request.httpBody = encodedHttpBody
        let task = session.dataTask(with: request) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, 200 ... 201 ~= httpResponse.statusCode else {
                completion(.failure(.responseError))
                return
            }

			do {
				let noteSequence = try Tensorflow_Magenta_NoteSequence(serializedData: data!)
				completion(.success(noteSequence))
			} catch {
				completion(.failure(.decodingError))
			}

//            do {
//                let sampleData = try JSONSerialization.jsonObject(with: jsonData, options: [])
//                completion(.success(sampleData as! [String: Any]))
//            } catch {
//                completion(.failure(.decodingError))
//            }
        }
        task.resume()
    }
}
