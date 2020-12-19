import Combine
import Utils
import Foundation

#if DEBUG
extension HeroProvider {
    static func mock(
        allHeros: @escaping (_ offset: Int) -> AnyPublisher<(heros: [Hero], total: Int), HeroProvider.Error> = { _ in
            .init(value: ([.fixture(), .fixture(id: 1)], 4))
        },
        squadHeros: @escaping () -> AnyPublisher<[Hero], HeroProvider.Error> = {
            .init(value: [.fixture()])
        },
        comicDetails: @escaping (Comic) -> AnyPublisher<Comic.Details, HeroProvider.Error> = { _ in
            .init(value: .fixture())
        },
        store: @escaping ([Hero]) -> AnyPublisher<Void, HeroProvider.Error> = { _ in
            .init(value: ())
        },
        imageData: @escaping (_ path: String) -> AnyPublisher<Data, HeroProvider.Error> = { _ in
            .init(value: Data())
        }
    ) -> HeroProviding {
        .init(
            allHeros: allHeros,
            comicDetails: comicDetails,
            squadHeros: squadHeros,
            store: store,
            imageData: imageData
        )
    }
}
#endif
