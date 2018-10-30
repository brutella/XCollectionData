import Foundation

extension XCollectionSection: Hashable {
    public var debugDescription: String {
        return self.rows.reduce(self.identifier, {
            description, row in
            
            return description + row.identifier
        })
    }
    
    public var hashValue: Int {
        return identifier.hashValue
    }
}

public func ==(lhs: XCollectionSection, rhs: XCollectionSection) -> Bool {
    return lhs.identifier == rhs.identifier
}