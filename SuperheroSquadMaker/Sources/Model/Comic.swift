struct Comic: Codable, Equatable, Hashable {
    let name: String
    let resourceURI: String

    var identifier: String? {
        resourceURI.components(separatedBy: "/").last
    }

    struct Details: Codable {
        let thumbnail: Thumbnail
    }
}

#if DEBUG
extension Comic {
    static func fixture(
        name: String = "Avengers: The Initiative (2007) #14",
        resourceURI: String = "http://gateway.marvel.com/v1/public/comics/21366"
    ) -> Self {
        .init(
            name: name,
            resourceURI: resourceURI
        )
    }
}

extension Comic.Details {
    static func fixture(
        thumbnail: Thumbnail = .fixture()
    ) -> Self {
        .init(
            thumbnail: thumbnail
        )
    }
}
#endif
