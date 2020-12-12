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
    }

    enum Event {
        enum Action {
            case didAppear
            case didPresentLast
        }

        case ui(Action)
        case initialize
        case loadHeros
        case didLoadSquad([Hero])
        case didLoadHeros([Hero], total: Int)
        case didFailToLoadSquad
        case didFailToLoadAllHeros
    }

    static let reducer: Reducer<State, Event, Environment> = .init { state, event, environment in
        switch event {
        case .initialize:
            return .init(value: .loadHeros)

        case .ui(.didAppear):
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
            return nil

        case .ui(.didPresentLast):
            return state.total > state.heros.count
                ? .init(value: .loadHeros)
                : nil
        }
    }
}

extension Root.ViewModel {
    func heroViewModel(hero: Hero) -> Root.HeroElement.ViewModel {
        .init(
            initialState: .init(hero: hero),
            reducer: Root.HeroElement.reducer,
            environment: .init(
                imageData: environment.heroProvider.imageData,
                mainQueue: environment.mainQueue,
                onAppear: self.heros.isLastItem(hero)
                    ? { [weak self] in self?.send(.ui(.didPresentLast)) }
                    : nil
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
                mainQueue: environment.mainQueue
            )
        )
    }
}
