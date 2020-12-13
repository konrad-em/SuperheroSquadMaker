import SwiftUI
import Utils

extension Root {
    struct ContentView: View {
        @ObservedObject private var viewModel: ViewModel

        init(viewModel: ViewModel) {
            self.viewModel = viewModel
            viewModel.send(.initialize)
        }

        var body: some View {
            NavigationView {
                ScrollView {
                    LazyVStack(spacing: .medium) {
                        if viewModel.squad.isNotEmpty {
                            SquadView {
                                ForEach(viewModel.squad, id: \.self) { hero in
                                    NavigationLink(
                                        destination: Details.ContentView(viewModel.detailsViewModel(hero: hero))
                                    ) {
                                        SquadHeroView(viewModel: viewModel.heroViewModel(hero: hero))
                                    }
                                }
                            }
                        }

                        if viewModel.heros.isNotEmpty {
                            ForEach(viewModel.heros, id: \.self) { hero in
                                NavigationLink(
                                    destination: Details.ContentView(viewModel.detailsViewModel(hero: hero))
                                ) {
                                    ListHeroView(viewModel: viewModel.heroViewModel(hero: hero))
                                }
                                .buttonStyle(ListHeroViewButtonStyle())
                            }
                        } else {
                            ActivityIndicator()
                        }
                    }
                    .padding(.vertical, .medium)
                }
                .onAppear { viewModel.send(.onAppear) }
                .navigationBarColor(.background)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .principal) { Image(.logo) } }
                .background(Color.background.ignoresSafeArea())
            }
        }
    }
}

struct ListHeroViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.darkGrayHighlight : Color.darkGray)
            .cornerRadius(.small)
            .padding(.horizontal, .medium)
    }
}
