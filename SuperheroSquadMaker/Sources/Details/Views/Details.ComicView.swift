import SwiftUI
import Utils

extension Details {
    struct ComicView: View {
        @ObservedObject private var viewModel: ComicElement.ViewModel

        init(viewModel: ComicElement.ViewModel) {
            self.viewModel = viewModel
            viewModel.send(.initialize)
        }

        var body: some View {
            VStack {
                Loading(viewModel.image) { data in
                    Image.with(data)
                        .resizable()
                        .scaledToFit()
                        .padding(.xSmall)
                        .border(Color.white, width: .xSmall)
                        .cornerRadius(.xSmall)
                }

                Text(viewModel.comic.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.small)

                Spacer()
            }
        }
    }
}
