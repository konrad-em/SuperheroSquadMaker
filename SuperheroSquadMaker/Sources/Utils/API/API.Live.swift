import Foundation
import Combine

public extension API {
    static var live: Self {
        .init(
            get: { resource in
                guard let request = resource.request else {
                    return AnyPublisher<R.Asset, API<R>.Error>(Fail(error: .invalidURL))
                }

                return URLSession.shared
                    .dataTaskPublisher(for: request)
                    .map { $0.0 }
                    .decode(type: R.Asset.self, decoder: resource.decoder)
                    .catch { error in AnyPublisher<R.Asset, API<R>.Error>(Fail(error: .other(error))) }
                    .eraseToAnyPublisher()
            }
        )
    }
}

public extension API where R == Data.Resource {
    static var live: Self {
        .init(
            get: { resource in
                guard let request = resource.request else {
                    return AnyPublisher<R.Asset, API<R>.Error>(Fail(error: .invalidURL))
                }

                return URLSession.shared
                    .dataTaskPublisher(for: request)
                    .map { $0.data }
                    .catch { error in AnyPublisher<R.Asset, API<R>.Error>(Fail(error: .other(error))) }
                    .eraseToAnyPublisher()
            }
        )
    }
}
