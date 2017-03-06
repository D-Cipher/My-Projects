import XCTest
import AutoLayout

class AutoLayoutTests: XCTestCase {
    func testInit() {
        let view1 = UIView()
        let view2 = UIView()

        var constraint = NSLayoutConstraint(item: view1, attribute: .Width)
        constraint.assert(item: view1, attribute: .Width)

        constraint = NSLayoutConstraint(item: view1, attribute: .Width, constant: 10)
        constraint.assert(item: view1, attribute: .Width, constant: 10)

        constraint = NSLayoutConstraint(item: view1, attribute: .Height, relation: .GreaterThanOrEqual, constant: 10)
        constraint.assert(item: view1, attribute: .Height, relation: .GreaterThanOrEqual, constant: 10)

        constraint = NSLayoutConstraint(item: view1, attribute: .Top, item: view2)
        constraint.assert(item: view1, attribute: .Top, item: view2)

        constraint = NSLayoutConstraint(item: view1, attribute: .Bottom, item: view2, constant: 10)
        constraint.assert(item: view1, attribute: .Bottom, item: view2, constant: 10)

        constraint = NSLayoutConstraint(item: view1, attribute: .Top, relation: .Equal, item: view2, attribute: .CenterY, multiplier: 2, constant: 10)
        constraint.assert(item: view1, attribute: .Top, relation: .Equal, item: view2, attribute: .CenterY, multiplier: 2, constant: 10)
    }
}

extension NSLayoutConstraint {
    func assert(item item1: AnyObject, attribute attribute1: NSLayoutAttribute, relation: NSLayoutRelation = .Equal, item item2: AnyObject? = nil, attribute attribute2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant constant: CGFloat = 0) {
        let attribute2: NSLayoutAttribute = item2 == nil ? .NotAnAttribute : (attribute2 ?? attribute1)
        XCTAssertTrue(firstItem === item1)
        XCTAssertEqual(firstAttribute, attribute1)
        XCTAssertEqual(self.relation, relation)
        XCTAssertTrue(secondItem === item2)
        XCTAssertEqual(secondAttribute, attribute2)
        XCTAssertEqual(self.multiplier, multiplier)
        XCTAssertEqual(self.constant, constant)
    }
}
