import Combine

extension Publisher where Output: Sequence {
    /// Maps the output to an array of the specified output type after applying a transform to each of the sequence's elements.
    public func mapArray<T>(_ transform: @escaping (Output.Element) -> T) -> Publishers.Map<Self, [T]> {
        self.map {
            $0.map(transform)
        }
    }
}
