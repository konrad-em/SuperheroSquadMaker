import Combine
import Disk

extension Cache {
    public static var live: Self {
        .init(
            store: { object, fileName in
                Future<Void, Error> { promise in
                    do {
                        try Disk.save(object, to: .caches, as: fileName)
                        return promise(.success(()))
                    } catch {
                        return promise(.failure(.unableToStore(error)))
                    }
                }
            },
            retrieve: { fileName in
                Future<T, Error> { promise in
                    do {
                        let object = try Disk.retrieve(fileName, from: .caches, as: T.self)
                        return promise(.success(object))
                    } catch {
                        return promise(.failure(.unableToRetrieve(error)))
                    }
                }
            }
        )
    }
}
