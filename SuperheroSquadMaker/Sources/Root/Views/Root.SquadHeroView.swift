import SwiftUI
import Utils

extension Root {
    struct SquadHeroView: View {
        @ObservedObject private var viewModel: HeroElement.ViewModel

        init(viewModel: HeroElement.ViewModel) {
            self.viewModel = viewModel
            viewModel.send(.initialize)
        }

        var body: some View {
            VStack {
                Loading(viewModel.image) { data in
                    Image.with(data)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: .xLarge, height: .xLarge)
                }

                VStack {
                    Text(viewModel.hero.name)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(height: .large)
            }
            .frame(maxWidth: .xLarge)
        }
    }
}
