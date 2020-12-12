import Combine

#if DEBUG
extension API {
    static func mock(
        get: @escaping (R) -> AnyPublisher<R.Asset, Error> = { _ in
            fatalError("Not implemented")
        }
    ) -> Self {
        .init(get: get)
    }
}
#endif
