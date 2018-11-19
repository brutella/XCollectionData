import Foundation

public enum PatchType {
    case insert, delete, noop
    
    public var debugDescription: String {
        get {
            switch self {
            case .insert: return "+"
            case .delete: return "-"
            case .noop: return "="
            }
        }
    }
}

/// Patch can be an insertion, deletion, or noop of elements.
public struct Patch<T> {
    public let type: PatchType
    public let elements: [T]
    
    public var elementsString: String {
        return elements.map({ "\($0)" }).joined(separator: ", ")
    }
    
    public var debugDescription: String {
        get {
            switch type {
            case .insert:
                return "[+\(elementsString)]"
            case .delete:
                return "[-\(elementsString)]"
            default:
                return "\(elementsString)"
            }
        }
    }
}

/// diff finds the difference between two lists.
/// This algorithm a shameless copy of simplediff https://github.com/paulgb/simplediff
///
/// - parameter before: Old list of elements.
/// - parameter after: New list of elements
/// - returns: A list of operation (insert, delete, noop) to transform the list *before* to the list *after*.
public func simplediff<T>(before: [T], after: [T]) -> [Patch<T>] where T: Hashable {
    // Create map of indices for every element
    var beforeIndices = [T: [Int]]()
    for (index, elem) in before.enumerated() {
        var indices = beforeIndices.index(forKey: elem) != nil ? beforeIndices[elem]! : [Int]()
        indices.append(index)
        beforeIndices[elem] = indices
    }
    
    var beforeStart = 0
    var afterStart = 0
    var maxOverlayLength = 0
    var overlay = [Int: Int]() // remembers *overlayLength* of previous element
    for (index, elem) in after.enumerated() {
        var _overlay = [Int: Int]()
        // Element must be in *before* list
        if let elemIndices = beforeIndices[elem] {
            // Iterate over element indices in *before*
            for elemIndex in elemIndices {
                var overlayLength = 1
                if let previousSub = overlay[elemIndex - 1] {
                    overlayLength += previousSub
                }
                _overlay[elemIndex] = overlayLength
                if overlayLength > maxOverlayLength { // longest overlay?
                    maxOverlayLength = overlayLength
                    beforeStart = elemIndex - overlayLength + 1
                    afterStart = index - overlayLength + 1
                }
            }
        }
        overlay = _overlay
    }
    
    var patches = [Patch<T>]()
    if maxOverlayLength == 0 {
        // No overlay; remove before and add after elements
        if before.count > 0 {
            patches.append(Patch(type: .delete, elements: before))
        }
        if after.count > 0 {
            patches.append(Patch(type: .insert, elements: after))
        }
    } else {
        // Recursive call with elements before overlay
        patches += simplediff(before: Array(before[0..<beforeStart]), after: Array(after[0..<afterStart]))
        // Noop for longest overlay
        patches.append(Patch(type: .noop, elements: Array(after[afterStart..<afterStart+maxOverlayLength])))
        // Recursive call with elements after overlay
        patches += simplediff(before: Array(before[beforeStart+maxOverlayLength..<before.count]), after: Array(after[afterStart+maxOverlayLength..<after.count]))
    }
    return patches
}
