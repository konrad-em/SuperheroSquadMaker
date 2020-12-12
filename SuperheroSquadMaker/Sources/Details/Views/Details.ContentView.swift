import SwiftUI
import Utils

extension Details {
    struct ContentView: View {
        @ObservedObject private var viewModel: ViewModel
        @SwiftUI.Environment(\.presentationMode) var mode: Binding<PresentationMode>

        init(_ viewModel: ViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Image.with(viewModel.image)
                                .resizable()
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.width
                                )

                            Text(viewModel.hero.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.all, .medium)

                            Button(action: {
                                viewModel.send(.ui(.didTapButton))
                            }) {
                                Text(
                                    viewModel.isSquadMember
                                        ? Localization.Details.fire
                                        : Localization.Details.hire
                                )
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                                .padding(.horizontal, .medium)
                                .buttonStyle(FireOrHireButtonStyle(isSquadMember: viewModel.isSquadMember))

                            Text(viewModel.hero.description)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.regular)
                                .padding(.all, .medium)

                            if viewModel.hero.comics.items.last != nil {
                                ComicsView {
                                    ForEach(viewModel.hero.comics.items, id: \.self) { item in
                                        ComicView(comic: item)
                                    }
                                }
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: { mode.wrappedValue.dismiss() }) {
                                    Image(.back)
                                }
                            }
                        }
                    }

                    StatusBarBlur(width: geometry.size.width).ignoresSafeArea()
                }
            }
            .onAppear { viewModel.send(.ui(.didAppear)) }
            .navigationBarColor(.clear)
            .background(Color.background)
            .ignoresSafeArea()
            .alert(isPresented:
                    Binding(
                        get: { viewModel.isPresentingAlert },
                        set: { _ in viewModel.send(.ui(.didDismissAlert)) }
                    )
            ) {
                 Alert(
                    title: Text(Localization.Details.confirm(viewModel.hero.name)),
                    primaryButton: .destructive(Text(Localization.Details.delete)) {
                        viewModel.send(.ui(.didTapConfirm))
                    },
                    secondaryButton: .cancel(Text(Localization.Details.cancel))
                )
            }
        }
    }
}

struct FireOrHireButtonStyle: ButtonStyle {
    let isSquadMember: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        if isSquadMember {
            return configuration.label
                .frame(height: .large)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: .small)
                        .stroke(
                            configuration.isPressed ? Color.accentHighlight : Color.accent,
                            style: StrokeStyle(lineWidth: 3)
                        )
                )
                .shadow(color: .accentGlow, radius: .medium)
                .eraseToAnyView()
        } else {
            return configuration.label
                .frame(height: .large)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(configuration.isPressed ? Color.accentHighlight : Color.accent)
                .cornerRadius(.small)
                .shadow(color: .accentGlow, radius: .medium)
                .eraseToAnyView()
        }
    }
}
