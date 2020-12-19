import SwiftUI
import Utils

extension Root {
    struct SquadView<Content: View>: View {
        let heros: Content

        init(@ViewBuilder heros: () -> Content) {
            self.heros = heros()
        }

        var body: some View {
            VStack(alignment: .leading) {
                Text(Localization.Root.squadTitle)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, .medium)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: .medium) {
                        heros
                    }
                    .padding(.leading, .medium)
                }
            }
        }
    }
}
