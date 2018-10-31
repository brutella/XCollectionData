#if os(iOS)
import UIKit

extension UICollectionView {
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
                let indices = op.elements.map({ $0.index }).compactMap({ $0 })
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
                let indexPaths = op.elements.map({ $0.indexPath }).compactMap({ $0 })
                switch op.type {
                case .insert:
                    self.insertItems(at: indexPaths)
                case .delete:
                    self.deleteItems(at: indexPaths)
                default:
                    break
                }
            }
        })
    }
}
#endif
