import Foundation

/// Represents a section in a two-dimensional collection
open class XCollectionSection {
    public let identifier: String
    public let title: String?
    public let footer: String?
    
    public var numberOfRows: Int {
        return self.rows.count
    }
    
    public var index: Int = Int.max {
        didSet {
            updateRowIndexPaths()
        }
    }
    
    public var rows = [XCollectionRow]()
    
    public init(identifier: String, title: String? = nil, footer: String? = nil) {
        self.identifier = identifier
        self.title = title
        self.footer = footer
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
        for (index, row) in self.rows.enumerated() {
            row.indexPath = IndexPath(indexes: [self.index, index])
        }
    }
}
