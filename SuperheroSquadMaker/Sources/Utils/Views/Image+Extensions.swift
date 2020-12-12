import SwiftUI

public extension Image {
    static func with(_ data: Data?) -> Image {
        data
            .flatMap(UIImage.init(data:))
            .map(Image.init(uiImage:))?
            .renderingMode(.original)
        ?? Image(uiImage: UIImage())
    }
}
