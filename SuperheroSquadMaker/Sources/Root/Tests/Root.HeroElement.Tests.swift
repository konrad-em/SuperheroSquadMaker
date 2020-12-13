import XCTest
import Combine
import CombineSchedulers
import Utils
@testable import SuperheroSquadMaker

class RootHeroElementTests: XCTestCase {
    func testHappyPath() {
        var didAppearCount: Int = 0
        var didLoadImageCount: Int = 0
        given { scheduler in
            Root.HeroElement.ViewModel(
                environment: .init(
                    imageData: { _ in .init(value: .fixture()) },
                    mainQueue: scheduler,
                    onAppear: { didAppearCount += 1 },
                    didLoadImage: { _, _ in didLoadImageCount += 1 }
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.initialize)
            scheduler.advance()
            viewModel.send(.onAppear)
            scheduler.advance()
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(hero: .fixture()),
                .init(hero: .fixture(), image: .fixture())

            ])
            XCTAssertEqual(didAppearCount, 1)
            XCTAssertEqual(didLoadImageCount, 1)
        }
    }

    func testErrorPath() {
        var didLoadImageCount: Int = 0
        var didAppearCount: Int = 0
        var didUpdateHeroImageData: Int = 0
        given { scheduler in
            Root.HeroElement.ViewModel(
                environment: .init(
                    imageData: { _ in
                        didLoadImageCount += 1
                        return Fail(error: HeroProvider.Error.imageCache(.unableToRetrieve(FakeError())))
                            .eraseToAnyPublisher()
                    },
                    mainQueue: scheduler,
                    onAppear: { didAppearCount += 1 },
                    didLoadImage: { _, _ in didUpdateHeroImageData += 1 }
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.initialize)
            scheduler.advance()
            viewModel.send(.onAppear)
            scheduler.advance()
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(hero: .fixture())
            ])
            XCTAssertEqual(didLoadImageCount, 1)
            XCTAssertEqual(didUpdateHeroImageData, 0)
            XCTAssertEqual(didAppearCount, 1)
        }
    }
}

private extension Root.HeroElement.ViewModel {
    convenience init(
        initialState: State = .init(hero: .fixture()),
        environment: Environment
    ) {
        self.init(
            initialState: initialState,
            reducer: Root.HeroElement.reducer,
            environment: environment
        )
    }
}
