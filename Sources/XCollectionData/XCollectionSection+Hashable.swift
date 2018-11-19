import Foundation

extension XCollectionSection: Hashable {   
    public var hashValue: Int {
        return identifier.hashValue
    }
}

public func ==(lhs: XCollectionSection, rhs: XCollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier
}
