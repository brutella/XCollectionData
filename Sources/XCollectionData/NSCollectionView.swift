#if os(macOS)
import AppKit

@available(macOS 10.11, *)
extension NSCollectionView {
    public func performUpdate(from old: XCollectionData, to new: XCollectionData) {
        let diff = new.diff(old)
        applySimplediff(diff)
    }
    
    public func applySimplediff(_ diff: Simplediff, performDataUpdates: (() -> Void)? = nil) {
        let insertOrDeleteSections = diff.sectionPatches.filter({ $0.type != .noop })
        let insertOrDeleteRows = diff.rowPatches.filter({ $0.type != .noop })
        
        if insertOrDeleteSections.count == 0 && insertOrDeleteRows.count == 0 {
            return
        }
        
        performBatchUpdates({
            performDataUpdates?()
            for op in insertOrDeleteSections {
                let indices = op.elements.map { return $0.index }
                let indexSet = IndexSet(indices)
                switch op.type {
                case .insert:
                    self.insertSections(indexSet)
                case .delete:
                    self.deleteSections(indexSet)
                default:
                    break
                }
            }
            
            for op in insertOrDeleteRows {
                let indexPaths = op.elements.map { return $0.indexPath }
                switch op.type {
                case .insert:
                    self.insertItems(at: Set(indexPaths))
                case .delete:
                    self.deleteItems(at: Set(indexPaths))
                default:
                    break
                }
            }
        })
    }
}
#endif
