import Utils
import Foundation

extension Hero {
    struct Resource: RequestConvertible {
        typealias Asset = Response<Hero>
        var pathComponents: [String] { ["v1", "public", "characters"] }
        var isAuthorized: Bool = true
        let offset: Int
        var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "limit", value: String(10)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        }
    }
}
