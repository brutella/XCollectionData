import Foundation

/// Represents the data in a UI-/NSCollectionView, UI-/NSTableView.
open class XCollectionData {
    public var sections = [XCollectionSection]()
    
    public var numberOfSections: Int {
        return self.sections.count
    }
    
    /// - Returns: The number of rows in the collection.
    public var numberOfRows: Int {
        var count = 0
        for section in sections {
            count += section.numberOfRows
        }
        
        return count
    }
    
    public init() {
        
    }
    
    public func section(at index: Int) -> XCollectionSection? {
        guard index < sections.count else {
            return nil
        }
        return sections[index]
    }
    
    public func row(at indexPath: IndexPath) -> XCollectionRow? {
        guard indexPath.count > 1 else {
            return nil
        }
        
        let first = indexPath[0] as Int
        let second = indexPath[1] as Int
        return section(at: first)?.row(at: second)
    }
    
    public func rows(at indexPaths: Set<IndexPath>) -> Set<XCollectionRow> {
        var rows = Set<XCollectionRow>()
        for indexPath in indexPaths {
            if let row = row(at: indexPath) {
                rows.insert(row)
            }
        }
        
        return rows
    }
    
    public func row(withIdentifier identifier: String) -> XCollectionRow? {
        for section in sections {
            for row in section.rows {
                if row.identifier == identifier {
                    return row
                }
            }
        }
        
        return nil
    }
    
    public func add(_ section: XCollectionSection) {
        section.index = sections.count
        self.sections.append(section)
    }
    
    public func add(_ sections: [XCollectionSection]) {
        for section in sections {
            self.add(section)
        }
    }
    
    @discardableResult
    public func moveRow(at source: IndexPath, to destination: IndexPath) -> Bool {
        guard source.count > 1 && destination.count > 1 else {
            return false
        }
        
        guard let sourceSection = section(at: source[0]), let destinationSection = section(at: destination[0]), let row = sourceSection.removeRow(at: source[1]) else {
            return false
        }
        
        destinationSection.add(row, at: destination[1])
        return true
    }
}
