import Combine

public struct Cache<T: Codable> {
    public var store: (_ object: T, _ fileName: String) -> Future<Void, Error>
    public var retrieve: (_ fileName: String) -> Future<T, Error>

    public enum Error: Swift.Error {
        case unableToStore(Swift.Error)
        case unableToRetrieve(Swift.Error)
    }
}
