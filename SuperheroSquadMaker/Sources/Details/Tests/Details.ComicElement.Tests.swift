import XCTest
import Combine
import CombineSchedulers
import Utils
@testable import SuperheroSquadMaker

class DetailsComicElementTests: XCTestCase {
    func testHappyPath() {
        var didLoadImageCount: Int = 0
        var didUpdateComicImageData: Int = 0
        var didLoadComicDetailsCount: Int = 0
        given { scheduler in
            Details.ComicElement.ViewModel(
                environment: Details.ComicElement.Environment(
                    comicDetails: { _ in
                        didLoadComicDetailsCount += 1
                        return .init(value: .fixture())
                    },
                    imageData: { _ in
                        didLoadImageCount += 1
                        return .init(value: .fixture())
                    },
                    mainQueue: scheduler,
                    didLoadImage: { _, _ in didUpdateComicImageData += 1 }
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.initialize)
            scheduler.advance()
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(comic: .fixture()),
                .init(comic: .fixture(), image: .fixture())
            ])
            XCTAssertEqual(didLoadImageCount, 1)
            XCTAssertEqual(didUpdateComicImageData, 1)
            XCTAssertEqual(didLoadComicDetailsCount, 1)
        }
    }

    func testErrorPath() {
        var didLoadImageCount: Int = 0
        var didUpdateComicImageData: Int = 0
        var didLoadComicDetailsCount: Int = 0
        given { scheduler in
            Details.ComicElement.ViewModel(
                environment: Details.ComicElement.Environment(
                    comicDetails: { _ in
                        didLoadComicDetailsCount += 1
                        return Fail(error: HeroProvider.Error.comicDetailsApi(.other(FakeError())))
                            .eraseToAnyPublisher()
                    },
                    imageData: { _ in
                        didLoadImageCount += 1
                        return Fail(error: HeroProvider.Error.imageCache(.unableToRetrieve(FakeError())))
                            .eraseToAnyPublisher()
                    },
                    mainQueue: scheduler,
                    didLoadImage: { _, _ in didUpdateComicImageData += 1 }
                )
            )
        }
        when: { viewModel, scheduler in
            viewModel.send(.initialize)
            scheduler.advance()
        }
        then: { states in
            XCTAssertEqual(states, [
                .init(comic: .fixture())
            ])
            XCTAssertEqual(didLoadImageCount, 0)
            XCTAssertEqual(didUpdateComicImageData, 0)
            XCTAssertEqual(didLoadComicDetailsCount, 1)
        }
    }
}

private extension Details.ComicElement.ViewModel {
    convenience init(
        initialState: State = .init(comic: .fixture()),
        environment: Environment
    ) {
        self.init(
            initialState: initialState,
            reducer: Details.ComicElement.reducer,
            environment: environment
        )
    }
}
