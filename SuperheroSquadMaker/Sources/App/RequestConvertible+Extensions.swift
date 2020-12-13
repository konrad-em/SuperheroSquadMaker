import Foundation
import Utils

public extension RequestConvertible {
    var url: URL? {
        var components = URLComponents()
        let ts = Date().timeIntervalSince1970.description
        let publicKey = Config.publicKey
        let privateKey = Config.privateKey
        let authorization: [URLQueryItem] = isAuthorized
            ? [
                .init(name: "ts", value: ts),
                .init(name: "apikey", value: publicKey),
                .init(name: "hash", value: MD5(string: ts + privateKey + publicKey))
            ]
            : []
        components.scheme = "https"
        components.host = Config.host
        components.path = "/" + pathComponents.joined(separator: "/")
        components.queryItems = queryItems + authorization
        return components.url
    }
}
