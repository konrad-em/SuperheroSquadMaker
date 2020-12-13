import XCTest
import Combine
import CombineSchedulers
import Utils
@testable import SuperheroSquadMaker

class RootTests: XCTestCase {
    func testHappyPath() {
        given { scheduler in
            Root.ViewModel(
                environment: .init(
                    heroProvider: HeroProvider.mock(),
                    mainQueue: scheduler
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.initialize)
            scheduler.advance()
            viewModel.send(.onAppear)
            scheduler.advance()
            viewModel.send(.didPresentLast)
            scheduler.advance()
            viewModel.send(.didPresentLast)
            scheduler.advance()
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(status: .loading),
                .init(
                    status: .idle,
                    squad: [],
                    heros: [.fixture(), .fixture(id: 1)],
                    total: 4
                ),
                .init(
                    status: .idle,
                    squad: [.fixture()],
                    heros: [.fixture(), .fixture(id: 1)],
                    total: 4
                ),
                .init(
                    status: .idle,
                    squad: [.fixture()],
                    heros: [.fixture(), .fixture(id: 1), .fixture(), .fixture(id: 1)],
                    total: 4
                )
            ])
        }
    }

    func testErrorPath() {
        var didTryToLoadSquadCount: Int = 0
        var didTryToLoadHerosCount: Int = 0
        var didTryToLoadImageCount: Int = 0
        given { scheduler in
            Root.ViewModel(
                environment: .init(
                    heroProvider: HeroProvider.mock(
                        allHeros: { _ in
                            didTryToLoadHerosCount += 1
                            return Fail(error: HeroProvider.Error.heroApi(.other(FakeError())))
                                .eraseToAnyPublisher()
                        },
                        squadHeros: {
                            didTryToLoadSquadCount += 1
                            return Fail(error: HeroProvider.Error.squadCache(.unableToRetrieve(FakeError())))
                                .eraseToAnyPublisher()
                        },
                        imageData: { _ in
                            didTryToLoadImageCount += 1
                            return Fail(error: HeroProvider.Error.imageCache(.unableToRetrieve(FakeError())))
                                .eraseToAnyPublisher()
                        }),
                    mainQueue: scheduler
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
                .init(status: .loading),
                .init(status: .idle)
                ]
            )
            XCTAssertEqual(didTryToLoadImageCount, 0)
            XCTAssertEqual(didTryToLoadSquadCount, 1)
            XCTAssertEqual(didTryToLoadHerosCount, 1)
        }
    }
}

private extension Root.ViewModel {
    convenience init(
        initialState: State = .init(),
        environment: Environment
    ) {
        self.init(
            initialState: initialState,
            reducer: Root.reducer,
            environment: environment
        )
    }
}
