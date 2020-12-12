import SwiftUI

extension Details {
    struct ComicView: View {
        private let comic: Comic

        init(comic: Comic) {
            self.comic = comic
        }

        var body: some View {
            VStack {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                Text(comic.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.small)
            }
        }
    }
}
