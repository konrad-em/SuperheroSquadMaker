import Combine
import Utils
import Foundation

typealias HeroAPI = API<Hero.Resource>
typealias ComicDetailsAPI = API<Comic.Details.Resource>
typealias ImageAPI = API<Data.Resource>
typealias SquadCache = Cache<[Hero]>
typealias ImageCache = Cache<Data>

struct HeroProvider {
    let heroApi: HeroAPI
    let comicDetailsApi: ComicDetailsAPI
    let imageApi: API<Data.Resource>
    let squadCache: SquadCache
    let imageCache: ImageCache

    enum Error: Swift.Error {
        case heroApi(HeroAPI.Error)
        case comicDetailsApi(ComicDetailsAPI.Error)
        case squadCache(SquadCache.Error)
        case imageApi(ImageAPI.Error)
        case imageCache(ImageCache.Error)
    }
}

struct HeroProviding {
    var allHeros: (_ offset: Int) -> AnyPublisher<(heros: [Hero], total: Int), HeroProvider.Error>
    var comicDetails: (Comic) -> AnyPublisher<Comic.Details, HeroProvider.Error>
    var squadHeros: () -> AnyPublisher<[Hero], HeroProvider.Error>
    var store: ([Hero]) -> AnyPublisher<Void, HeroProvider.Error>
    var imageData: (_ path: String) -> AnyPublisher<Data, HeroProvider.Error>
}
