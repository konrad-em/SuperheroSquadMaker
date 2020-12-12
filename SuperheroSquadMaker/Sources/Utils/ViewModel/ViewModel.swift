import Combine

@dynamicMemberLookup
public final class ViewModel<State, Event, Environment>: ObservableObject {
    @Published private(set) var state: State
    public let environment: Environment
    private let reducer: Reducer<State, Event, Environment>
    private var cancellables: Set<AnyCancellable> = []

    public init(
        initialState: State,
        reducer: Reducer<State, Event, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    public func send(_ event: Event) {
        guard let effect = reducer.run(&state, event, environment) else { return }
        effect
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }

    public subscript<U>(dynamicMember keyPath: KeyPath<State, U>) -> U {
        return state[keyPath: keyPath]
    }
}

public struct Reducer<State, Event, Environment> {
    private let reduce: (inout State, Event, Environment) -> AnyPublisher<Event, Never>?

    public init(
        _ reduce: @escaping (inout State, Event, Environment) -> AnyPublisher<Event, Never>?
    ) {
        self.reduce = reduce
    }

    public func run(
        _ state: inout State,
        _ event: Event,
        _ environment: Environment
    ) -> AnyPublisher<Event, Never>? {
        reduce(&state, event, environment)
    }
}
