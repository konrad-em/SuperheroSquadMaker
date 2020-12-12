import Foundation

public protocol RequestConvertible {
    associatedtype Asset: Decodable

    var queryItems: [URLQueryItem] { get }
    var request: URLRequest? { get }
    var pathComponents: [String] { get }
    var decoder: JSONDecoder { get }
    var isAuthorized: Bool { get }
    var url: URL? { get }
}

public extension RequestConvertible {
    var queryItems: [URLQueryItem] { return [] }
    var pathComponents: [String] { return [] }
    var isAutorized: Bool { return false }
    var url: URL? {
        var components = URLComponents()
        let ts = Date().timeIntervalSince1970.description
        let publicKey = "71e742407ca8b4ac76c4917a1c199a09"
        let privateKey = "67a407d72945a9b1ee019145174ae42a02b7117d"
        let authorization: [URLQueryItem] = isAuthorized
            ? [
                URLQueryItem(name: "ts", value: ts),
                URLQueryItem(name: "apikey", value: publicKey),
                URLQueryItem(name: "hash", value: MD5(string: ts + privateKey + publicKey))
            ]
            : []
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.path = "/" + pathComponents.joined(separator: "/")
        components.queryItems = queryItems + authorization
        return components.url
    }
    var request: URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
    var decoder: JSONDecoder { JSONDecoder() }
}
