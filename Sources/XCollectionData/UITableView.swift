#if os(iOS)
import UIKit

extension UITableView {
    public func performUpdate(from old: XCollectionData, to new: XCollectionData, rowAnimation: UITableView.RowAnimation = .fade) {
        let diff = new.diff(old)
        applySimplediff(diff, withRowAnimation: rowAnimation)
    }
    
    public func applySimplediff(_ diff: Simplediff, withRowAnimation rowAnimation: UITableView.RowAnimation = .fade) {
        let insertOrDeleteSections = diff.sectionPatches.filter { $0.type != .noop }
        let insertOrDeleteRows = diff.rowPatches.filter { $0.type != .noop }
        
        if insertOrDeleteSections.count == 0 && insertOrDeleteRows.count == 0 {
            return
        }
        
        beginUpdates()
        for op in insertOrDeleteSections {
            let indices = op.elements.map { return $0.index }
            let indexSet = IndexSet(indices)
            switch op.type {
            case .insert:
                self.insertSections(indexSet, with: rowAnimation)
            case .delete:
                self.deleteSections(indexSet, with: rowAnimation)
            default:
                break
            }
        }
        
        for op in insertOrDeleteRows {
            let indexPaths = op.elements.map { return $0.indexPath }
            switch op.type {
            case .insert:
                self.insertRows(at: indexPaths, with: rowAnimation)
            case .delete:
                self.deleteRows(at: indexPaths, with: rowAnimation)
            default:
                break
            }
        }
        endUpdates()
    }
}
#endif
