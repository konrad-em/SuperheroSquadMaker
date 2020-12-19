import XCTest
import Combine
import CombineSchedulers
import Utils
@testable import SuperheroSquadMaker

class DetailsTests: XCTestCase {
    func testHappyPath() {
        var imageData: [Data] = [.fixture(), .fixture(bytes: [])]
        var didGetImageDataCount: Int = 0
        var didStoreSquadCount: Int = 0
        let heroProviderMock = HeroProvider.mock(
            store: { _ in
                didStoreSquadCount += 1
                return .init(value: ())
            },
            imageData: { _ in
                didGetImageDataCount += 1
                let data = imageData.last
                imageData = imageData.dropLast()
                return .init(value: data!)
            }
        )

        given { scheduler in
            Details.ViewModel(
                environment: .init(
                    store: heroProviderMock.store,
                    imageData: heroProviderMock.imageData,
                    comicDetails: heroProviderMock.comicDetails,
                    mainQueue: scheduler
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.onAppear)
            scheduler.advance()
            viewModel.send(.ui(.didTapFireOrHireButton))
            viewModel.send(.ui(.didTapFireOrHireButton))
            viewModel.send(.ui(.didTapConfirm))
            scheduler.advance()
            viewModel.send(.ui(.didDismissAlert))
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(hero: .fixture(), squad: []),
                .init(hero: .fixture(), image: .fixture(bytes:[]), squad: []),
                .init(hero: .fixture(), image: .fixture(), squad: []),
                .init(hero: .fixture(), image: .fixture(), squad: [.fixture()]),
                .init(hero: .fixture(), image: .fixture(), squad: [.fixture()], isPresentingAlert: true),
                .init(hero: .fixture(), image: .fixture(), squad: [], isPresentingAlert: true),
                .init(hero: .fixture(), image: .fixture(), squad: [])
            ])
            XCTAssertEqual(didGetImageDataCount, 2)
            XCTAssertEqual(didStoreSquadCount, 2)
        }
    }

    func testErrorPath() {
        var didGetImageDataCount: Int = 0
        var didStoreSquadCount: Int = 0
        let heroProviderMock = HeroProvider.mock(
            store: { _ in
                didStoreSquadCount += 1
                return Fail(error: HeroProvider.Error.squadCache(.unableToStore(FakeError())))
                    .eraseToAnyPublisher()
            },
            imageData: { _ in
                didGetImageDataCount += 1
                return Fail(error: HeroProvider.Error.imageCache(.unableToRetrieve(FakeError())))
                    .eraseToAnyPublisher()
            }
        )

        given { scheduler in
            Details.ViewModel(
                environment: .init(
                    store: heroProviderMock.store,
                    imageData: heroProviderMock.imageData,
                    comicDetails: heroProviderMock.comicDetails,
                    mainQueue: scheduler
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.onAppear)
            scheduler.advance()
            viewModel.send(.ui(.didTapFireOrHireButton))
            viewModel.send(.ui(.didTapFireOrHireButton))
            viewModel.send(.ui(.didTapConfirm))
            scheduler.advance()
            viewModel.send(.ui(.didDismissAlert))
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(hero: .fixture(), squad: []),
                .init(hero: .fixture(), squad: [.fixture()]),
                .init(hero: .fixture(), squad: [.fixture()], isPresentingAlert: true),
                .init(hero: .fixture(), squad: [], isPresentingAlert: true),
                .init(hero: .fixture(), squad: [])
            ])
            XCTAssertEqual(didGetImageDataCount, 2)
            XCTAssertEqual(didStoreSquadCount, 2)
        }
    }
}

private extension Details.ViewModel {
    convenience init(
        initialState: State = .init(
            hero: .fixture(),
            squad: []
        ),
        environment: Environment
    ) {
        self.init(
            initialState: initialState,
            reducer: Details.reducer,
            environment: environment
        )
    }
}
