protocol CatBreedListServiceProtocol {
    func fetchCatBreedListPage(pageSize: Int,marker: Int) async throws -> [Model.CatBreedListEntry]
}

class CatBreedListService: CatBreedListServiceProtocol {
    let httpClient = HttpClient()

    func fetchCatBreedListPage(pageSize: Int, marker: Int) async throws -> [Model.CatBreedListEntry] {
        try await httpClient.getJSON("/breeds?limit=\(pageSize)&page=\(marker)")
    }
}
