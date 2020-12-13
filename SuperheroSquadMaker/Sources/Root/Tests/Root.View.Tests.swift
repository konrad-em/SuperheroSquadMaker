import XCTest
import SwiftUI
import Utils
import SnapshotTesting

@testable import SuperheroSquadMaker

class RootViewTests: XCTestCase {
    private let heroToImageData = [
        Hero.fixture(): Data.fakeImage,
        Hero.fixture(id: 1): Data.fakeImage
    ]

    func test_loading_with_squad() {
        verify(
            state: .init(
                status: .loading,
                squad: [.fixture()],
                heroImageData: heroToImageData
            )
        )
    }

    func test_loading_without_squad() {
        verify(
            state: .init(
                status: .loading,
                heroImageData: heroToImageData
            )
        )
    }

    func test_idle_with_squad() {
        verify(
            state: .init(
                status: .idle,
                squad: [.fixture()],
                heros: [.fixture(), .fixture(id: 1)],
                heroImageData: heroToImageData
            )
        )
    }

    func test_idle_without_squad() {
        verify(
            state: .init(
                status: .idle,
                squad: [],
                heros: [.fixture(), .fixture(id: 1)],
                heroImageData: heroToImageData
            )
        )
    }
}

extension RootViewTests {
    private func verify(
        state: Root.State,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
     ) {
        let viewModel: ViewModel = .empty(with: state)
        assertSnapshot(
            matching: Root.ContentView(viewModel: viewModel),
            as: .image,
            file: file,
            testName: testName,
            line: line
        )
    }
}

extension Root.ViewModel {
    static func empty(with state: State) -> Self {
        .init(
            initialState: state,
            reducer: .empty(),
            environment: .init()
        )
    }
}
