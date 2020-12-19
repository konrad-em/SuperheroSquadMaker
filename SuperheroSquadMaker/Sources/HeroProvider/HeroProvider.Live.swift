import Combine
import Utils
import Foundation

private let kSquadCache = "io.perpetuum.SuperheroSquadMaker.Root.squadHeroCache"

extension HeroProvider {
    var live: HeroProviding {
        HeroProviding(
            allHeros: { offset in
                heroApi.get(Hero.Resource(offset: offset))
                    .map { ($0.data.results, $0.data.total) }
                    .catch { AnyPublisher<(heros: [Hero], total: Int), HeroProvider.Error>(Fail(error: .heroApi($0))) }
                    .eraseToAnyPublisher()
            },
            comicDetails: { comic in
                comicDetailsApi.get(Comic.Details.Resource(identifier: comic.identifier))
                    .map(\.data.results.first)
                    .compactMap { $0 }
                    .catch { AnyPublisher<Comic.Details, HeroProvider.Error>(Fail(error: .comicDetailsApi($0))) }
                    .eraseToAnyPublisher()
            },
            squadHeros: {
                squadCache.retrieve(kSquadCache)
                    .catch { AnyPublisher<[Hero], HeroProvider.Error>(Fail(error: .squadCache($0))) }
                    .eraseToAnyPublisher()
            },
            store: { heros in
                squadCache.store(heros, kSquadCache)
                    .catch { AnyPublisher<Void, HeroProvider.Error>(Fail(error: .squadCache($0))) }
                    .eraseToAnyPublisher()
            },
            imageData: { path in
                imageCache.retrieve(path)
                    .catch { _ in
                        imageApi.get(Data.Resource(path: path))
                            .catch { AnyPublisher<Data, HeroProvider.Error>(Fail(error: .imageApi($0))) }
                            .handleEvents(receiveOutput: {
                                _ = imageCache.store($0, path)
                            })
                    }
                    .eraseToAnyPublisher()
            }
        )
    }
}
