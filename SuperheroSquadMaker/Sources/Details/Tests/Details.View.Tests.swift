import XCTest
import SwiftUI
import Utils
import SnapshotTesting

@testable import SuperheroSquadMaker

class DetailsViewTests: XCTestCase {
    func test_hero_in_the_squad() {
        verify(
            state: .init(
                hero: .fixture(),
                image: UIImage(named: "detail")!.jpegData(compressionQuality: 1),
                squad: [.fixture()]
            )
        )
    }

    func test_hero_not_in_the_squad() {
        verify(
            state: .init(
                hero: .fixture(),
                image: UIImage(named: "detail")!.jpegData(compressionQuality: 1),
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
            mainQueue: DispatchQueue.main.eraseToAnyScheduler()
        )
    }
}