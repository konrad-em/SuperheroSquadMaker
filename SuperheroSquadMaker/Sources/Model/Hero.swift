struct Hero: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Thumbnail
    let comics: Comics
}

extension Hero: Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#if DEBUG
extension Hero {
    static func fixture(
        id: Int = 1017100,
        name: String = "A-Bomb (HAS)",
        description: String = "Rick Jones has been Hulk's best bud since day one ...!",
        thumbnail: Thumbnail = .fixture(),
        comics: Comics = .fixture()
    ) -> Self {
        .init(
            id: id,
            name: name,
            description: description,
            thumbnail: thumbnail,
            comics: comics
        )
    }
}
#endif
