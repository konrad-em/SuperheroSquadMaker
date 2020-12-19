import CombineSchedulers
import Combine
import Utils

extension Details {
    enum ComicElement {
        typealias ViewModel = Utils.ViewModel<State, Event, Environment>

        struct State: Equatable {
            let comic: Comic
            var image: Data?
        }

        struct Environment {
            let comicDetails: (Comic) -> AnyPublisher<Comic.Details, HeroProvider.Error>
            let imageData: (String) -> AnyPublisher<Data, HeroProvider.Error>
            let mainQueue: AnySchedulerOf<DispatchQueue>
            let didLoadImage: (Data, Comic) -> Void
        }

        enum Event {
            case initialize
            case didLoadImage(Data)
            case didFailToLoadImage
        }

        static let reducer: Reducer<State, Event, Environment> = .init { state, event, environment in
            switch event {
            case .initialize:
                guard state.image == nil else { return nil }
                return environment.comicDetails(state.comic)
                    .flatMap { environment.imageData($0.thumbnail.path(size: .portrait)) }
                    .map(Event.didLoadImage)
                    .replaceError(with: .didFailToLoadImage)
                    .receive(on: environment.mainQueue)
                    .eraseToAnyPublisher()

            case let .didLoadImage(data):
                environment.didLoadImage(data, state.comic)
                state.image = data
                return nil

            case .didFailToLoadImage:
                state.image = nil
                return nil
            }
        }
    }
}
