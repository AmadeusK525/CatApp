protocol CatBreedDetailsServiceProtocol {
    func fetchDetails(id: String) async throws -> Model.CatBreed
    func fetchImage(id: String) async throws -> Model.RemoteImage
}

class CatBreedDetailsService: CatBreedDetailsServiceProtocol {
    private let httpClient = HttpClient()

    func fetchDetails(id: String) async throws -> Model.CatBreed {
        try await self.httpClient.getJSON("/breeds/\(id)")
    }

    func fetchImage(id: String) async throws -> Model.RemoteImage {
        try await self.httpClient.getJSON("/images/\(id)")
    }
}
