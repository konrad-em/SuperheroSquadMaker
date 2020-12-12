struct Comics: Codable, Equatable {
    let available: Int
    let items: [Comic]
}

#if DEBUG
extension Comics {
    static func fixture(
        available: Int = 12,
        items: [Comic] = [.fixture()]
    ) -> Self {
        .init(
            available: available,
            items: items
        )
    }
}
#endif
