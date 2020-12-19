import SwiftUI

public struct ActivityIndicator: View {
    public var body: some View {
        UIViewRepresented(makeUIView: { _ in
            let view = UIActivityIndicatorView(style: .large)
            view.startAnimating()
            return view
        })
    }

    public init() { }
}
