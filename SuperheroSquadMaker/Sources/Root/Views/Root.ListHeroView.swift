import SwiftUI
import Utils

extension Root {
    struct ListHeroView: View {
        @ObservedObject private var viewModel: HeroElement.ViewModel

        init(viewModel: HeroElement.ViewModel) {
            self.viewModel = viewModel
            viewModel.send(.initialize)
        }

        var body: some View {
            HStack {
                Image.with(viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: .large, height: .large)
                    .padding(.all, .medium)

                Text(viewModel.hero.name)
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Spacer()
                Image(.arrow)
                    .padding(.horizontal, .medium)
            }
            .onAppear { viewModel.send(.onAppear) }
        }
    }
}
