import XCTest
import Combine
import CombineSchedulers
import Utils
@testable import SuperheroSquadMaker

class RootHeroElementTests: XCTestCase {
    func testHappyPath() {
        var didAppearCount: Int = 0
        given { scheduler in
            Root.HeroElement.ViewModel(
                environment: .init(
                    imageData: { _ in .init(value: .fixture()) },
                    mainQueue: scheduler,
                    onAppear: { didAppearCount += 1 }
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.initialize)
            scheduler.advance()
            viewModel.send(.ui(.didAppear))
            scheduler.advance()
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(hero: .fixture()),
                .init(hero: .fixture(), image: .fixture())

            ])
            XCTAssertEqual(didAppearCount, 1)
        }
    }
}

extension Root.HeroElement.ViewModel {
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
