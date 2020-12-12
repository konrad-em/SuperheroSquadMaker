import Foundation

public extension Data {
    struct Resource: RequestConvertible {
        public typealias Asset = Data
        public var isAuthorized: Bool = false
        let path: String

        public var url: URL? {
            URL(string: path.replacingOccurrences(of: "http", with: "https"))
        }

        public init(path: String) {
            self.path = path
        }
    }
}
