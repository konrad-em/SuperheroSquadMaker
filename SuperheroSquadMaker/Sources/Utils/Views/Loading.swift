import SwiftUI

public struct Loading<Value, Content: View>: View {
    private let value: Value?
    private let contentProvider: (Value) -> Content

    public init(
        _ value: Value?,
        @ViewBuilder content: @escaping (Value) -> Content
    ) {
        self.value = value
        self.contentProvider = content
    }

    public var body: some View {
        ZStack {
            ActivityIndicator()
            value.map(contentProvider)
        }
    }
}
