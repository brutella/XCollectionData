import XCTest
@testable import XCollectionData

final class XCollectionDataTests: XCTestCase {
    func testData() {
        let data = XCollectionData()
        
        let section = XCollectionSection(identifier:"test")
        section.add(XCollectionRow(identifier:"row1"))
        section.add(XCollectionRow(identifier:"row2"))
        data.add(section)
        
        XCTAssertEqual(data.numberOfSections, 1)
        XCTAssertEqual(data.numberOfRows, 2)
        
        let row1IndexPath =  IndexPath(indexes: [0, 0])
        guard let row1 = data.row(at: row1IndexPath) else {
            XCTFail("No row at (0,0)")
            return
        }
        
        XCTAssertEqual(row1.identifier, "row1")
        
        let row2IndexPath =  IndexPath(indexes: [0, 1])
        guard let row2 = data.row(at: row2IndexPath) else {
            XCTFail("No row at (0,1)")
            return
        }
        
        XCTAssertEqual(row2.identifier, "row2")
    }
    
    func testDataDiff() {
        let old = XCollectionData()
        let oldSection1 = XCollectionSection(identifier:"section1")
        let oldRow1 = XCollectionRow(identifier:"row1")
        let oldRow2 = XCollectionRow(identifier:"row2")
        oldSection1.add(oldRow1)
        oldSection1.add(oldRow2)
        old.add(oldSection1)
        
        let new = XCollectionData()
        let newSection1 = XCollectionSection(identifier:"section1")
        let newRow11 = XCollectionRow(identifier:"row1")
        let newRow12 = XCollectionRow(identifier:"row2")
        let newRow13 = XCollectionRow(identifier:"row3")
        newSection1.add(newRow11)
        newSection1.add(newRow12)
        newSection1.add(newRow13)
        
        let newSection2 = XCollectionSection(identifier:"section2")
        let newRow21 = XCollectionRow(identifier:"row1")
        newSection2.add(newRow21)
        
        new.add(newSection1)
        new.add(newSection2)
        
        let diff = new.diff(old)
        XCTAssertEqual(diff.sectionPatches.count, 2)
        
        guard let noopSectionPatch = diff.sectionPatches.first, let insertSectionPatch = diff.sectionPatches.last else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(noopSectionPatch.type, .noop)
        XCTAssertEqual(insertSectionPatch.type, .insert)
        
        XCTAssertEqual(diff.rowPatches.count, 2)
        guard let noopRowsPatch = diff.rowPatches.first, let insertRowPatch = diff.rowPatches.last else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(noopRowsPatch.elements, [newRow11, newRow12])
        XCTAssertEqual(insertRowPatch.elements, [newRow13])
    }

    static var allTests = [
        ("testData", testData),
    ]
}
