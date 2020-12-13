import XCTest
import SwiftUI
import Utils
import SnapshotTesting

@testable import SuperheroSquadMaker

class DetailsViewTests: XCTestCase {
    func testHeroInTheSquad() {
        verify(
            state: .init(
                hero: .fixture(),
                image: .fakeImage,
                squad: [.fixture()],
                comicImageData: [.fixture(): .fakeImage]
            )
        )
    }

    func testHeroNotInTheSquad() {
        verify(
            state: .init(
                hero: .fixture(),
                image: .fakeImage,
                squad: [],
                comicImageData: [.fixture(): .fakeImage]
            )
        )
    }

    func testLoadingComics() {
        verify(
            state: .init(
                hero: .fixture(),
                image: .fakeImage,
                squad: []
            )
        )
    }
}

extension DetailsViewTests {
    private func verify(
        state: Details.State,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
     ) {
        let viewModel: ViewModel = .empty(with: state)
        assertSnapshot(
            matching: Details.ContentView(viewModel),
            as: .image,
            file: file,
            testName: testName,
            line: line
        )
    }
}

extension Details.ViewModel {
    static func empty(with state: State) -> Self {
        .init(
            initialState: state,
            reducer: .empty(),
            environment: .mock
        )
    }
}

extension Details.Environment {
    static var mock: Self {
        .init(
            store: HeroProvider.mock().store,
            imageData: HeroProvider.mock().imageData,
            comicDetails: HeroProvider.mock().comicDetails,
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    }
}
