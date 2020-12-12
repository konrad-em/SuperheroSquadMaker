import Combine

#if DEBUG
extension Cache {
    static func mock(
        store: @escaping (_ object: T, _ fileName: String) -> Future<Void, Error> = { _, _ in
            fatalError("Not implemented")
        },
        retrieve: @escaping (_ fileName: String) -> Future<T, Error> = { _ in
            fatalError("Not implemented")
        }
    ) -> Self {
        .init(
            store: store,
            retrieve: retrieve
        )
    }
}
#endif
