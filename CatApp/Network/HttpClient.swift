import Foundation

class HttpClient {
    let baseUrl: String
    let apiKey: String?

    init(baseUrl: String = Environment.apiUrl, apiKey: String? = Environment.apiKey) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }

    func get(_ path: String, contentType: ContentType) async throws -> Data {
        let urlStr = "\(self.baseUrl)\(path)"
        let url = URL(string: urlStr)

        guard let url else {
            throw HttpError.invalidUrl(urlStr)
        }

        print("Making request to \(urlStr)")

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        if let apiKey {
            req.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        }

        let (data, res) = try await URLSession.shared.data(for: req)

        guard let httpResponse = res as? HTTPURLResponse else {
            throw HttpError.badResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw HttpError.errorCode(httpResponse.statusCode, data.description)
        }

        return data
    }

    func getJSON<T: Decodable>(_ path: String) async throws -> T {
        let data = try await self.get(path, contentType: .applicationJSON)
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)

        return decoded
    }
}

extension HttpClient {
    enum HttpError: LocalizedError, CustomStringConvertible {
        case invalidUrl(String)
        case badResponse
        case errorCode(Int, String)
        case invalidFormat

        var description: String {
            switch self {
            case .invalidUrl(let urlStr):
                return "Cannot construct valid URL from value \(urlStr)"
            case .badResponse:
                return "Server returned bad data"
            case .errorCode(let code, let message):
                return "Request returned error code \(code): \(message)"
            case .invalidFormat:
                return "Response did not return expected format for request"
            }
        }
    }
}

extension HttpClient {
    enum ContentType: String {
        case applicationJSON = "application/json"
        case imageJPEG = "image/jpeg"
        case imagePNG = "image/png"
    }
}
