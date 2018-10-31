import Foundation

/// Represents a row in a two-dimensional collection
open class XCollectionRow {
    public let identifier: String
    internal(set) public var indexPath: IndexPath?
    
    public init(identifier: String) {
        self.identifier = identifier
    }
}
