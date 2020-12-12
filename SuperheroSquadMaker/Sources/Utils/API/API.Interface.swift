import Foundation
import Combine

public struct API<R: RequestConvertible> {
    public var get: (R) -> AnyPublisher<R.Asset, Error>

    public enum Error: Swift.Error {
        case invalidURL
        case other(Swift.Error)
    }

    public init(get: @escaping (R) -> AnyPublisher<R.Asset, Error>) {
        self.get = get
    }
}

public struct Response<T: Decodable>: Decodable {
    public struct Data: Decodable {
        public let results: [T]
        public let total: Int
    }
    public let data: Data
}
