import SwiftUI

public struct Blur: View {
    let style: UIBlurEffect.Style

    public var body: some View {
        UIViewRepresented(makeUIView: { _ in
            let view = UIView(frame: CGRect.zero)
            view.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: style)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(blurView, at: 0)
            NSLayoutConstraint.activate([
                blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
                blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
            return view
        })
    }

    public init(style: UIBlurEffect.Style) {
        self.style = style
    }
}

public struct StatusBarBlur: View {
    public let width: CGFloat

    public init(width: CGFloat) {
        self.width = width
    }

    public var body: some View {
        Color.clear
            .frame(width: width, height: 20.0)
            .background(Blur(style: .regular))
    }
}
