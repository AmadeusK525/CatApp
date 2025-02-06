import SwiftUI

protocol CatBreedListCardServiceProtocol {
    func fetchImage(id: String) async throws -> UIImage
}

class CatBreedListCardService: CatBreedListCardServiceProtocol {
    let httpClient = HttpClient()

    func fetchImage(id: String) async throws -> UIImage {
        let imageDetails: Model.RemoteImage = try await httpClient.getJSON("/images/\(id)")

        let plainHttpClient = HttpClient(baseUrl: "", apiKey: nil)
        let imageData = try await plainHttpClient.get(imageDetails.url, contentType: .imageJPEG)
        let image = UIImage(data: imageData)

        guard let image else {
            throw CatListCardServiceError.invalidImageData
        }

        return image
    }
}

extension CatBreedListCardService {
    enum CatListCardServiceError: Error {
        case invalidImageData
    }
}
