import SwiftUI

extension Root {
    struct SquadHeroView: View {
        @ObservedObject private var viewModel: HeroElement.ViewModel

        init(viewModel: HeroElement.ViewModel) {
            self.viewModel = viewModel
            viewModel.send(.initialize)
        }

        var body: some View {
            VStack {
                Image.with(viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: .xLarge, height: .xLarge)
                Text(viewModel.hero.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .xLarge)
        }
    }
}
