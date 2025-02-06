extension Model {
    struct RemoteImage: Identifiable, Codable {
        let id: String
        let url: String
        let width: Int
        let height: Int
    }
}
