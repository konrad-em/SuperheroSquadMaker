import Utils
import Foundation

extension Comic.Details {
    struct Resource: RequestConvertible {
        typealias Asset = Response<Comic.Details>

        let identifier: String?
        var pathComponents: [String] { ["v1", "public", "comics", identifier].compactMap { $0 } }
        var isAuthorized: Bool = true
    }
}
