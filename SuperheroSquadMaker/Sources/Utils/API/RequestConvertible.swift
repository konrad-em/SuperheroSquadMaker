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
    var request: URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
    var decoder: JSONDecoder { JSONDecoder() }
}
