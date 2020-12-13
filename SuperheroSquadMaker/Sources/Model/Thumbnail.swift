import Utils

struct Thumbnail: Codable, Equatable {
    let path: String
    let `extension`: String
}

extension Thumbnail {
    enum Size: String {
        case large = "detail"
        case small = "standard_medium"
        case portrait = "portrait_fantastic"
    }

    func path(size: Size) -> String {
        "\(path)/" + "\(size.rawValue)." + "\(`extension`)"
    }
}

#if DEBUG
extension Thumbnail {
    static func fixture(
        path: String = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
        `extension`: String = "jpg"
    ) -> Self {
        .init(
            path: path,
            extension: `extension`
        )
    }
}
#endif
