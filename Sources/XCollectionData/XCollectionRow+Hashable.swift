import Foundation

extension XCollectionRow: Hashable {
    public var hashValue: Int {
        return identifier.hashValue
    }
}

public func ==(lhs: XCollectionRow, rhs: XCollectionRow) -> Bool {
    return lhs.identifier == rhs.identifier
}