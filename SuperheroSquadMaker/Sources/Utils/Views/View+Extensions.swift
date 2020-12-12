import SwiftUI

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

public extension View {
    func navigationBarColor(_ backgroundColor: Color) -> some View {
        modifier(NavigationBarModifier(backgroundColor: UIColor(backgroundColor)))
    }
}
