public extension Reducer {
    static func empty() -> Reducer<State, Event, Environment> {
        .init { _, _, _ in nil }
    }
}
