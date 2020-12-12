import SwiftUI

extension Details {
    struct ComicsView<Content: View>: View {
        let comics: Content

        init(@ViewBuilder comics: () -> Content) {
            self.comics = comics()
        }

        var body: some View {
            Text(Localization.Details.lastAppearance)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, .medium)
                .padding(.vertical, .small)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                alignment: .leading,
                spacing: .medium
            ) {
                comics
            }
            .padding(.medium)
        }
    }
}
