public extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

public extension RandomAccessCollection where Self.Element: Identifiable {
    func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard
            isNotEmpty,
            let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) })
        else { return false }
        return distance(from: itemIndex, to: endIndex) == 1
    }
}
