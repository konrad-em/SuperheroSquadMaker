import Utils
import Foundation

extension Hero {
    struct Resource: RequestConvertible {
        typealias Asset = Response<Hero>
        let offset: Int
        var pathComponents: [String] { ["v1", "public", "characters"] }
        var isAuthorized: Bool = true
        var queryItems: [URLQueryItem] {
            [
                .init(name: "limit", value: String(10)),
                .init(name: "offset", value: String(offset))
            ]
        }
    }
}
