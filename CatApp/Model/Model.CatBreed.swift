extension Model {
    struct CatBreed: Identifiable, Decodable {
        let id: String
        let name: String
        let description: String
        let origin: String
        let reference_image_id: String
        let life_span: String
        let wikipedia_url: String
    }
}
