struct Comic: Codable, Equatable, Hashable {
    let name: String
    let resourceURI: String
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
#endif
