import UIKit

extension Data {
    static func fixture(bytes: [UInt8] = [0xFF, 0xFF]) -> Self {
        return .init(bytes: bytes, count: bytes.count)
    }

    static var fakeImage: Self {
        UIImage(named: "detail")!.jpegData(compressionQuality: 1)!
    }
}
