import Combine

extension AnyPublisher {
    public init(value: Output) {
        self.init(Just(value).setFailureType(to: Failure.self))
    }
}
