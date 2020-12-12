import CombineSchedulers
import Combine
import Utils

extension Root {
    enum HeroElement {
        typealias ViewModel = Utils.ViewModel<State, Event, Environment>

        struct State: Equatable {
            let hero: Hero
            var image: Data?
        }

        struct Environment {
            let imageData: (String) -> AnyPublisher<Data, HeroProvider.Error>
            let mainQueue: AnySchedulerOf<DispatchQueue>
            let onAppear: (() -> Void)?
        }

        enum Event {
            enum Action {
                case didAppear
            }

            case initialize
            case ui(Action)
            case didLoadImage(Data)
            case didFailToLoadImage
        }

        static let reducer: Reducer<State, Event, Environment> = .init { state, event, environment in
            switch event {
            case .initialize:
                return environment.imageData(state.hero.thumbnail.path(size: .small))
                    .map(Event.didLoadImage)
                    .replaceError(with: .didFailToLoadImage)
                    .receive(on: environment.mainQueue)
                    .eraseToAnyPublisher()

            case .ui(.didAppear):
                environment.onAppear?()
                return nil

            case let .didLoadImage(data):
                state.image = data
                return nil

            case .didFailToLoadImage:
                state.image = nil
                return nil
            }
        }
    }
}
