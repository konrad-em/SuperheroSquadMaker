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
            viewModel.send(.ui(.didAppear))
            scheduler.advance()
            viewModel.send(.ui(.didPresentLast))
            scheduler.advance()
            viewModel.send(.ui(.didPresentLast))
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
}

extension Root.ViewModel {
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
