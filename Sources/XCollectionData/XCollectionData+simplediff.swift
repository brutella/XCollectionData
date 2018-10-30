import Foundation

public struct Simplediff {
    public let sectionPatches: [Patch<XCollectionSection>]
    public let rowPatches: [Patch<XCollectionRow>]
}

extension XCollectionData {
    public func diff(_ before: XCollectionData) -> Simplediff {
        let sectionPatches = simplediff(before: before.sections, after: self.sections)
        var rowPatches = [Patch<XCollectionRow>]()
        for change in sectionPatches {
            switch change.type {
            case .noop:
                for section in change.elements {
                    guard let beforeSection = before.sections.filter({ $0.identifier == section.identifier }).first else {
                        assertionFailure("Cannot find section with description \(section.identifier)")
                        continue
                    }
                    
                    let changes = simplediff(before: beforeSection.rows, after: section.rows)
                    rowPatches.append(contentsOf: changes)
                }
            default:
                // Insert or delete change already include row changes
                break
            }
        }
        
        return Simplediff(sectionPatches: sectionPatches, rowPatches: rowPatches)
    }
}
