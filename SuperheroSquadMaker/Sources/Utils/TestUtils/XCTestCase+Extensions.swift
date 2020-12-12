import CombineSchedulers
import Combine
import XCTest
@testable import Utils

extension XCTestCase {
    func given<State: Equatable, Event, Environment>(
        stub: (AnySchedulerOf<DispatchQueue>) -> Utils.ViewModel<State, Event, Environment>,
        when: (Utils.ViewModel<State, Event, Environment>, TestSchedulerOf<DispatchQueue>) throws -> Void,
        then: @escaping ([State]) -> Void
    ) rethrows {
        var cancellables = Set<AnyCancellable>()
        var states = [State]()
        let scheduler = DispatchQueue.testScheduler
        let viewModel = stub(scheduler.eraseToAnyScheduler())
        viewModel.$state
            .removeDuplicates()
            .sink(receiveValue: { states.append($0) })
            .store(in: &cancellables)
        try when(viewModel, scheduler)
        then(states)
    }
}
