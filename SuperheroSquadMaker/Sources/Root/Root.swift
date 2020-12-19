import Combine
import Utils
import CombineSchedulers
import SwiftUI

enum Root {
    typealias ViewModel = Utils.ViewModel<State, Event, Environment>

    static func make() -> some View {
        ContentView(
            viewModel: .init(
                initialState: .init(),
                reducer: reducer,
                environment: .init()
            )
        )
    }

    struct Environment {
        let heroProvider: HeroProviding
        let mainQueue: AnySchedulerOf<DispatchQueue>

        init(
            heroProvider: HeroProviding = HeroProvider(
                heroApi: HeroAPI.live,
                comicDetailsApi: ComicDetailsAPI.live,
                imageApi: ImageAPI.live,
                squadCache: SquadCache.live,
                imageCache: ImageCache.live
            ).live,
            mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
        ) {
            self.heroProvider = heroProvider
            self.mainQueue = mainQueue
        }
    }

    struct State: Equatable {
        enum Status: Equatable {
            case loading
            case idle
        }

        var status: Status = .loading
        var squad: [Hero] = []
        var heros: [Hero] = []
        var total: Int = 0
        var heroImageData: [Hero: Data] = [:]
    }

    enum Event {
        case onAppear
        case didPresentLast
        case initialize
        case loadHeros
        case didLoadSquad([Hero])
        case didLoadHeros([Hero], total: Int)
        case didLoadImageData(Data, Hero)
        case didFailToLoadSquad
        case didFailToLoadAllHeros
    }

    static let reducer: Reducer<State, Event, Environment> = .init { state, event, environment in
        switch event {
        case .initialize:
            return .init(value: .loadHeros)

        case .onAppear:
            return environment.heroProvider.squadHeros()
                .map(Event.didLoadSquad)
                .replaceError(with: .didFailToLoadSquad)
                .receive(on: environment.mainQueue)
                .eraseToAnyPublisher()

        case .loadHeros:
            return environment.heroProvider
                .allHeros(state.heros.count)
                .map(Event.didLoadHeros)
                .replaceError(with: Event.didFailToLoadAllHeros)
                .receive(on: environment.mainQueue)
                .eraseToAnyPublisher()

        case let .didLoadSquad(heros):
            state.status = .idle
            state.squad = heros
            return nil

        case let .didLoadHeros(heros, total):
            state.status = .idle
            state.total = total
            state.heros += heros
            return nil

        case .didFailToLoadSquad:
            return nil

        case .didFailToLoadAllHeros:
            state.status = .idle
            return nil

        case .didPresentLast:
            return state.total > state.heros.count
                ? .init(value: .loadHeros)
                : nil

        case let .didLoadImageData(data, hero):
            state.heroImageData[hero] = data
            return nil
        }
    }
}

extension Root.ViewModel {
    func heroViewModel(hero: Hero) -> Root.HeroElement.ViewModel {
        .init(
            initialState: .init(hero: hero, image: self.heroImageData[hero]),
            reducer: Root.HeroElement.reducer,
            environment: .init(
                imageData: environment.heroProvider.imageData,
                mainQueue: environment.mainQueue,
                onAppear: self.heros.isLastItem(hero)
                    ? { [weak self] in self?.send(.didPresentLast) }
                    : nil,
                didLoadImage: { [weak self] data, hero in self?.send(.didLoadImageData(data, hero)) }
            )
        )
    }

    func detailsViewModel(hero: Hero) -> Details.ViewModel {
        .init(
            initialState: .init(
                hero: hero,
                squad: self.squad
            ),
            reducer: Details.reducer,
            environment: .init(
                store: environment.heroProvider.store,
                imageData: environment.heroProvider.imageData,
                comicDetails: environment.heroProvider.comicDetails,
                mainQueue: environment.mainQueue
            )
        )
    }
}
