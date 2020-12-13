import Utils
import SwiftUI
import Combine
import CombineSchedulers

enum Details {
    typealias ViewModel = Utils.ViewModel<State, Event, Environment>

    struct Environment {
        let store: ([Hero]) -> AnyPublisher<Void, HeroProvider.Error>
        let imageData: (String) -> AnyPublisher<Data, HeroProvider.Error>
        let comicDetails: (Comic) -> AnyPublisher<Comic.Details, HeroProvider.Error>
        let mainQueue: AnySchedulerOf<DispatchQueue>
    }

    struct State: Equatable {
        let hero: Hero
        var image: Data?
        var squad: [Hero]
        var isPresentingAlert: Bool = false
        var comicImageData: [Comic: Data] = [:]
        var isSquadMember: Bool { squad.contains(hero) }
        var visibleComics: [Comic] { hero.comics.items.suffix(2) }
        var numberOfRemainingComics: Int { hero.comics.items.count - visibleComics.count }
    }

    enum Event {
        enum Action {
            case didDismissAlert
            case didTapFireOrHireButton
            case didTapConfirm
        }

        case onAppear
        case ui(Action)
        case didLoadImage(Data)
        case didFailToLoadImage
        case didLoadComicImageData(Data, Comic)
        case storeSquad
        case didStoreSquad
        case didFailToStoreSquad
    }

    static let reducer: Reducer<State, Event, Environment> = .init { state, event, environment in
        switch event {
        case .onAppear:
            return Publishers.Merge(
                environment.imageData(state.hero.thumbnail.path(size: .small)),
                environment.imageData(state.hero.thumbnail.path(size: .large))
            )
            .map(Event.didLoadImage)
            .replaceError(with: .didFailToLoadImage)
            .receive(on: environment.mainQueue)
            .eraseToAnyPublisher()

        case let .didLoadComicImageData(data, comic):
            state.comicImageData[comic] = data
            return nil

        case let .didLoadImage(data):
            state.image = data
            return nil

        case .didFailToLoadImage:
            state.image = nil
            return nil

        case .ui(.didTapFireOrHireButton):
            guard state.isSquadMember else {
                state.squad.append(state.hero)
                return .init(value: .storeSquad)
            }
            state.isPresentingAlert = true
            return nil

        case .ui(.didTapConfirm):
            state.squad = state.squad.filter { $0 != state.hero }
            return .init(value: .storeSquad)

        case .ui(.didDismissAlert):
            state.isPresentingAlert = false
            return nil

        case .storeSquad:
            return environment.store(state.squad)
                .map { _ in Event.didStoreSquad }
                .replaceError(with: Event.didFailToStoreSquad)
                .receive(on: environment.mainQueue)
                .eraseToAnyPublisher()

        case .didStoreSquad, .didFailToStoreSquad:
            return nil
        }
    }
}

extension Details.ViewModel {
    func comicViewModel(comic: Comic) -> Details.ComicElement.ViewModel {
        .init(
            initialState: .init(comic: comic, image: self.comicImageData[comic]),
            reducer: Details.ComicElement.reducer,
            environment: .init(
                comicDetails: environment.comicDetails,
                imageData: environment.imageData,
                mainQueue: environment.mainQueue,
                didLoadImage: { [weak self] data, comic in self?.send(.didLoadComicImageData(data, comic)) }
            )
        )
    }
}
