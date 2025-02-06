extension Model {
    struct CatBreedListEntry: Identifiable, Codable {
        let id: String
        let name: String
        let origin: String
        let reference_image_id: String
    }
}
