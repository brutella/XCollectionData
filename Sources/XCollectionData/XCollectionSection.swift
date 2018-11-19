import Foundation

/// Represents a section in a two-dimensional collection
open class XCollectionSection {
    public let identifier: String
    
    public var debugDescription: String {
        return identifier + "\n" + rows.map({ $0.identifier }).joined(separator: "\n\t")
    }
    
    public var numberOfRows: Int {
        return self.rows.count
    }
    
    internal(set) public var index: Int? {
        didSet {
            updateRowIndexPaths()
        }
    }
    
    public var rows = [XCollectionRow]()
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public func add(_ row: XCollectionRow) {
        self.rows.append(row)
        updateRowIndexPaths()
    }
    
    public func add(_ row: XCollectionRow, at index: Int) {
        self.rows.insert(row, at: index)
        updateRowIndexPaths()
    }
    
    public func add(_ rows: [XCollectionRow]) {
        self.rows.append(contentsOf: rows)
        updateRowIndexPaths()
    }
    
    public func removeRow(at index: Int) -> XCollectionRow? {
        guard index < rows.count else {
            return nil
        }
        
        let row = rows.remove(at: index)
        updateRowIndexPaths()
        return row
    }
    
    public func row(at index: Int) -> XCollectionRow? {
        guard index < rows.count else {
            return nil
        }
        return self.rows[index]
    }
    
    // MARK: - Private
    
    private func updateRowIndexPaths() {
        guard let section = self.index else {
            return
        }
        
        for (index, row) in self.rows.enumerated() {
            row.indexPath = IndexPath(indexes: [section, index])
        }
    }
}
