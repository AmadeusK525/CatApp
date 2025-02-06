import Foundation

extension Model {
    struct CatListEntry: Identifiable, Decodable {
        let id: String
        let url: String
        let breeds: [CatBreedListEntry]
    }
}
