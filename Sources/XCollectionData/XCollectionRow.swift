import Foundation

/// Represents a row in a two-dimensional collection
open class XCollectionRow {
    public let identifier: String
    public var indexPath: IndexPath = IndexPath(indexes: [Int.max, Int.max])
    
    public init(identifier: String) {
        self.identifier = identifier
    }
}
