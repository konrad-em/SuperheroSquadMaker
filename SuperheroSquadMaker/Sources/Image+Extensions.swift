import SwiftUI

extension Image {
    enum Identifier: String {
        case arrow
        case back
        case logo
    }

    init(_ identifier: Identifier) {
        self.init(identifier.rawValue)
    }
}
